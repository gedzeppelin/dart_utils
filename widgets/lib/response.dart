import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show Response, StreamedResponse;
import 'package:tuple/tuple.dart';

// ANCHOR Exceptions and extensions.

class BadStatusCodeException implements Exception {
  const BadStatusCodeException([this.message = 'BadStatusCodeException']);
  final String message;
  String toString() => message;
}

class EmptyPaginatorException implements Exception {
  const EmptyPaginatorException([this.message = 'EmptyPaginatorException']);
  final String message;
  String toString() => message;
}

class NoDataMatchesException implements Exception {
  const NoDataMatchesException([this.message = 'NoDataMatchesException']);
  final String message;
  String toString() => message;
}

class MultipleResponseException implements Exception {
  const MultipleResponseException([this.message = 'Some of your multiple responses have failed']);
  final String message;
  String toString() => message;
}

extension IsResponseSuccessful on http.Response {
  bool get isSuccessful => statusCode > 199 && statusCode < 300;
}

extension IsStreamedResponseSuccessful on http.StreamedResponse {
  bool get isSuccessful => statusCode > 199 && statusCode < 300;
}

// ANCHOR Response declaration.

class Response<T extends Object> {
  const Response._internal();

  factory Response.error(Exception exception) = Failed<T>;

  factory Response.success(T payload) = Successful<T>;

  bool get isSuccessful => this is Successful<T>;

  /// Builds a [Response] with HTTP's response status code comparison.
  static Future<Response<T>> deserialize<T extends Object>({
    @required Future<http.Response> httpRequest,
    @required T Function(Map<String, dynamic> decodedBody) deserializer,
  }) async {
    try {
      final response = await httpRequest;
      if (response.isSuccessful) {
        final decodedBody = json.decode(response.body) as Map<String, dynamic>;
        final result = deserializer(decodedBody);
        return Response<T>.success(result);
      } else {
        return Response<T>.error(BadStatusCodeException());
      }
    } on Exception catch (e) {
      return Response<T>.error(e);
    }
  }

  /// Builds a [Response] with HTTP's response status code comparison.
  static Future<Response<T>> deserializePaginated<T extends Object>({
    @required Future<http.Response> httpRequest,
    @required T Function(Iterable decodedBody) deserializer,
  }) async {
    try {
      final response = await httpRequest;
      if (response.isSuccessful) {
        final decodedBody = json.decode(response.body) as Iterable;
        final result = deserializer(decodedBody);
        return Response<T>.success(result);
      } else {
        return Response<T>.error(BadStatusCodeException());
      }
    } on Exception catch (e) {
      return Response<T>.error(e);
    }
  }

  ///
  static Future<bool> checkSuccess(Future<http.Response> httpRequest) async {
    try {
      final response = await httpRequest;
      return response.isSuccessful;
    } catch (_) {
      return false;
    }
  }

  ///
  static Future<Response<Tuple4<T, S, U, V>>> await4<T, S, U, V>(
    Future<Response<T>> future0,
    Future<Response<S>> future1,
    Future<Response<U>> future2,
    Future<Response<V>> future3,
  ) async {
    final responses = await Future.wait([future0, future1, future2, future3]);

    final response0 = responses[0] as Response<T>;
    final response1 = responses[1] as Response<S>;
    final response2 = responses[2] as Response<U>;
    final response3 = responses[3] as Response<V>;

    return response0 is Successful<T> &&
            response1 is Successful<S> &&
            response2 is Successful<U> &&
            response3 is Successful<V>
        ? Response.success(Tuple4(
            response0.payload,
            response1.payload,
            response2.payload,
            response3.payload,
          ))
        : Response.error(MultipleResponseException());
  }
}

// ANCHOR Response variants.

class Successful<T extends Object> extends Response<T> {
  const Successful(this.payload) : super._internal();

  final T payload;
}

class Failed<T extends Object> extends Response<T> {
  const Failed(this.exception) : super._internal();

  final Exception exception;
}
