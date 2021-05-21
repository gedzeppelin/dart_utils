import "dart:convert" show json, utf8;

import 'package:enigma_core/enigma_core.dart';
import "package:http/http.dart" as http;

part "response_ext.dart";
part "types.dart";

// ANCHOR Exception messages and extensions.

extension IsResponseSuccessful on http.Response {
  bool get isSuccessful => statusCode > 199 && statusCode < 300;
}

extension IsStreamedResponseSuccessful on http.StreamedResponse {
  bool get isSuccessful => statusCode > 199 && statusCode < 300;
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
    required T payload,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKinds? notifyKind,
  }) = Ok<T>;

  factory Response.err({
    dynamic payload,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKinds? notifyKind,
  }) = Err<T>;

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  void notify([NotifyKinds? kind, Notifier? notifier]);
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
  final T payload;

  Ok({
    required this.payload,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKinds? notifyKind,
  }) : super._internal(requestURL, status, message) {
    this.notify(notifyKind);
  }

  @override
  void notify([NotifyKinds? kind, Notifier? notifier]) {
    final _notifier = notifier ?? options.notifier;
    if (_notifier != null) {
      final _kind = kind ?? options.response.notifyKind;
      if (_kind == NotifyKinds.ifErr || _kind == NotifyKinds.always) {
        final _message = message ?? options.response.successMessage();
        _notifier.success("${options.response.successLabel()}:\n${_message}");
      }
    }
  }

  @override
  void fold({
    IfOkFold<T>? ifOk,
    IfErrFold<T>? ifErr,
  }) =>
      ifOk?.call(this);

  @override
  A map<A>({
    required IfOkMap<T, A> ifOk,
    required IfErrMap<T, A> ifErr,
  }) =>
      ifOk(this);
}

// ANCHOR Err variants.

class Err<T> extends Response<T> implements Exception {
  late final String? _error;
  late final List<ErrInfo>? _messages;

  Err({
    dynamic payload,
    Uri? requestURL,
    int? status,
    String? message,
    NotifyKinds? notifyKind,
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
        final propErrors = x.errors.map((y) => y.toString()).join(", ");
        return "- ${x}: ${propErrors}";
      }).join("\n");
    }

    return options.response.errorMessage();
  }

  //Err<A> toType<A>();

  @override
  void notify([NotifyKinds? kind, Notifier? notifier]) {
    final _notifier = notifier ?? options.notifier;
    if (_notifier != null) {
      final _kind = kind ?? options.response.notifyKind;
      if (_kind == NotifyKinds.ifErr || _kind == NotifyKinds.always) {
        _notifier.error("${options.response.errorLabel()}:\n${getError()}");
      }
    }
  }

  @override
  void fold({
    IfOkFold<T>? ifOk,
    IfErrFold<T>? ifErr,
  }) =>
      ifErr?.call(this);

  @override
  A map<A>({
    required IfOkMap<T, A> ifOk,
    required IfErrMap<T, A> ifErr,
  }) =>
      ifErr(this);
}
