import 'package:dio/dio.dart';
import 'package:enigma_annotation/enigma_annotation.dart';
import "package:enigma_core/enigma_core.dart";
import "package:dio/dio.dart" as dio;

part "make_any.dart";
part "make_multiple.dart";
part "make_object.dart";
part "make_paginator.dart";
part "types.dart";

// ANCHOR Exception messages and extensions.

extension IsResponseSuccessful on dio.Response {
  bool get isSuccessful =>
      statusCode != null && statusCode! > 199 && statusCode! < 300;
}

// ANCHOR Response declaration.

abstract class Response<T> {
  final Uri? requestURL;
  final int? status;
  final String? message;

  const Response._internal([
    this.requestURL,
    this.status,
    this.message,
  ]);

  factory Response.ok({
    required T value,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKind? notifyKind,
  }) = Ok<T>;

  factory Response.err({
    dynamic payload,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKind? notifyKind,
  }) = Err<T>;

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  void notify([NotifyKind? kind, Notifier? notifier]);
  void fold({
    IfOkFold<T>? ifOk,
    IfErrFold<T>? ifErr,
  });
  A map<A>({
    required IfOkMap<T, A> ifOk,
    required IfErrMap<T, A> ifErr,
  });
}

// ANCHOR Ok variant.

class Ok<T> extends Response<T> {
  final T value;

  Ok({
    required this.value,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKind? notifyKind,
  }) : super._internal(requestURL, status, message) {
    this.notify(notifyKind);
  }

  @override
  void notify([NotifyKind? kind, Notifier? notifier]) {
    final _notifier = notifier ?? defaults.notifier;
    if (_notifier != null) {
      final _kind = kind ?? defaults.response.notifyKind;
      if (_kind == NotifyKind.ifOk || _kind == NotifyKind.always) {
        final _message = message ?? defaults.response.successMessage();
        _notifier.success("${defaults.response.successLabel()}:\n${_message}");
      }
    }
  }

  @override
  void fold({
    IfOkFold<T>? ifOk,
    IfErrFold<T>? ifErr,
  }) =>
      ifOk?.call(this.value, this);

  @override
  A map<A>({
    required IfOkMap<T, A> ifOk,
    required IfErrMap<T, A> ifErr,
  }) =>
      ifOk(this.value, this);
}

// ANCHOR Err variants.

class Err<T> extends Response<T> implements Exception {
  final Object? error;

  String? _error = null;
  List<ErrInfo>? _messages = null;

  Err({
    this.error,
    dynamic payload,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKind? notifyKind,
  }) : super._internal(requestURL, status, message) {
    if (payload is Map<String, dynamic>) {
      final error = payload["error"];
      if (error is String) {
        this._error = error;
      }

      final messages = payload["messages"];
      if (messages is List && messages.length > 0) {
        final List<ErrInfo> messagesAux = [];

        for (final item in messages) {
          if (item is Map<String, dynamic>) {
            final property = item["property"];
            final errors = item["errors"];

            if (property is String && errors is List) {
              messagesAux.add(ErrInfo(property, errors));
            }
          }
        }

        if (messagesAux.length > 0) {
          this._messages = messagesAux;
        }
      }
    } else if (payload is String) {
      this._error = payload;
    }

    this.notify(notifyKind);
  }

  bool hasData() =>
      _error != null || (_messages != null && _messages!.length > 0);

  String getError() {
    final _message = super.message;
    if (_message != null) {
      return _message;
    }

    final _error = this._error;
    if (_error != null) {
      return _error;
    }

    final _messages = this._messages;
    if (_messages != null && _messages.length > 0) {
      return _messages.map((x) {
        final propErrors = x.errors.map((y) => y.toString()).join("\n");
        return "- ${x.property}:\n${propErrors}";
      }).join("\n");
    }

    return defaults.response.errorMessage();
  }

  @override
  void notify([NotifyKind? kind, Notifier? notifier]) {
    final _notifier = notifier ?? defaults.notifier;
    if (_notifier != null) {
      final _kind = kind ?? defaults.response.notifyKind;
      if (_kind == NotifyKind.ifErr || _kind == NotifyKind.always) {
        _notifier.error("${defaults.response.errorLabel()}:\n${getError()}");
      }
    }
  }

  @override
  void fold({
    IfOkFold<T>? ifOk,
    IfErrFold<T>? ifErr,
  }) =>
      ifErr?.call(this.error, this);

  @override
  A map<A>({
    required IfOkMap<T, A> ifOk,
    required IfErrMap<T, A> ifErr,
  }) =>
      ifErr(this.error, this);
}
