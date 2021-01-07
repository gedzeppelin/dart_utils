import "dart:convert" show json;

import "package:dartz/dartz.dart";
import 'package:enigma_dart/enigma.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http show Response, StreamedResponse;
import "package:pagination_annotation/pagination_annotation.dart";

part "response.u.dart";

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
  factory Response.errMultiple(IList<Err> errors, [int requestCount]) = ErrMultiple<T>;

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

abstract class Err<T> extends Response<T> {
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
  String toString() => stackTrace?.toString() ?? error.toString();

  @override
  ErrInternal<A> toType<A>() => ErrInternal<A>(error, stackTrace);
}

class ErrExternal<T> extends Err<T> {
  const ErrExternal(this.response) : super._internal();

  final http.Response response;

  String get rawBody => response.body;

  @override
  String toString() => "Request status code: ${response.statusCode}";

  @override
  ErrExternal<A> toType<A>() => ErrExternal<A>(response);
}

class ErrMultiple<T> extends Err<T> {
  const ErrMultiple(this.errors, [this.requestCount]) : super._internal();

  final IList<Err> errors;
  final int requestCount;

  @override
  String toString() => requestCount != null
      ? "There have been ${errors.length()} errors of the $requestCount HTTP requests:\n$_runtimeErrors"
      : "${errors.length()} errors have been occurred";
  //String toString() => errors.mapWithIndex((e, i) => "$i: ${e.toString()}").toIterable().join("\n");

  String get _runtimeErrors => errors.mapWithIndex((i, e) => "$i: ${e.runtimeType.toString()}").toList().join("\n");

  @override
  ErrMultiple<A> toType<A>() => ErrMultiple<A>(errors);
}
