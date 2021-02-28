import "dart:convert" show json, utf8;

import "package:dartz/dartz.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http show Response, StreamedResponse;
import "package:pagination_annotation/pagination_annotation.dart";

part "response_ext.dart";

// ANCHOR Type definitions.

typedef Deserializer<T> = T Function(Map<String, dynamic> decodedBody);

typedef IfOk<T, A> = A Function(T payload);
typedef IfErr<T, A> = A Function(Err<T> err);
typedef Condition<T> = bool Function(T payload);

// ANCHOR Exception messages and extensions.

extension IsResponseSuccessful on http.Response {
  bool get isSuccessful => statusCode > 199 && statusCode < 300;
}

extension IsStreamedResponseSuccessful on http.StreamedResponse {
  bool get isSuccessful => statusCode > 199 && statusCode < 300;
}

// ANCHOR Response declaration.

abstract class Response<T> {
  static const int defaultAttempts = 3;

  const Response._internal();

  factory Response.ok(T payload) = Ok<T>;
  factory Response.err(Object error, [StackTrace stackTrace]) = ErrInternal<T>;
  factory Response.errExternal(http.Response response) = ErrExternal<T>;
  factory Response.errMultiple(List<Err> errors, [int requestCount]) = ErrMultiple<T>;

  bool get isSuccessful => this is Ok<T>;

  A fold<A>(IfOk<T, A> ifOk, IfErr<T, A> ifErr);

  Response<A> map<A>(IfOk<T, A> mapOk) => fold((p) => Ok<A>(mapOk(p)), (e) => e.toType<A>());
  A mapOr<A>(A def, IfOk<T, A> mapOk) => fold((p) => mapOk(p), (e) => def);
  A mapOrElse<A>(IfErr<T, A> mapErr, IfOk<T, A> mapOk) => fold((p) => mapOk(p), (e) => mapErr(e));
}

// ANCHOR Ok variant.

class Ok<T> extends Response<T> {
  const Ok(this.payload) : super._internal();

  final T payload;

  @override
  A fold<A>(IfOk<T, A> ifOk, IfErr<T, A> ifErr) => ifOk(payload);
}

// ANCHOR Err variants.

abstract class Err<T> extends Response<T> implements Exception {
  const Err._internal() : super._internal();

  Err<A> toType<A>();

  @override
  A fold<A>(IfOk<T, A> ifOk, IfErr<T, A> ifErr) => ifErr(this);
}

class ErrInternal<T> extends Err<T> {
  const ErrInternal(this.error, [this.stackTrace]) : super._internal();

  final Object error;
  final StackTrace stackTrace;

  @override
  String toString() => error.toString();

  @override
  ErrInternal<A> toType<A>() => ErrInternal<A>(error, stackTrace);
}

class ErrExternal<T> extends Err<T> {
  const ErrExternal(this.response) : super._internal();

  final http.Response response;

  String get rawBody => utf8.decode(response.bodyBytes);
  dynamic get body => json.decode(rawBody);

  @override
  String toString() {
    final _rawBody = rawBody;

    if (_rawBody != null) {
      final _body = body;
      if (_body != null && _body is Map<String, dynamic> && _body.containsKey("message")) {
        return _body["message"];
      }

      return _rawBody;
    }

    return "URL: ${response.request.url}\nStatus code: ${response.statusCode}";
  }

  @override
  ErrExternal<A> toType<A>() => ErrExternal<A>(response);
}

class ErrMultiple<T> extends Err<T> {
  const ErrMultiple(this.errors, [this.requestCount]) : super._internal();

  final List<Err> errors;
  final int requestCount;

  @override
  String toString() {
    final internal = errors.whereType<ErrInternal>();
    if (internal.length > 0) {
      return internal.first.toString();
    }

    final external = errors.whereType<ErrExternal>();
    if (external.length > 0) {
      return external.first.toString();
    }

    return requestCount != null
        ? "There have been ${errors.length} errors of the $requestCount HTTP requests:\n\n$_runtimeErrors"
        : "${errors.length} errors have been occurred:\n----\n$_runtimeErrors\n";
  }

  String get _runtimeErrors => errors.asMap().entries.map((e) => "${e.key} [${e.runtimeType}]:\n${e.value}").join("\n");

  @override
  ErrMultiple<A> toType<A>() => ErrMultiple<A>(errors, requestCount);
}
