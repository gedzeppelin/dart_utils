part of "response.dart";

Future<Response> _makeAny(
  Future<http.Response> httpRequest,
  Uri url,
  int? attempts,
  NotifyKind? notify,
  String? message,
) async {
  final _attempts = attempts ?? options.response.attempts;

  for (var i = 0; i < _attempts; i++) {
    try {
      final httpResponse = await httpRequest;

      if (httpResponse.isSuccessful) {
        final stringBody = utf8.decode(httpResponse.bodyBytes);
        final body = json.decode(stringBody);

        return Ok(
          payload: body,
          requestURL: httpResponse.request?.url,
          status: httpResponse.statusCode,
          notifyKind: notify,
          message: message,
        );
      } else if (i + 1 == _attempts) {
        final stringBody = utf8.decode(httpResponse.bodyBytes);
        final body = json.decode(stringBody);

        return Err(
          payload: body,
          requestURL: httpResponse.request?.url,
          status: httpResponse.statusCode,
          notifyKind: notify,
          message: message,
        );
      }
    } catch (err) {
      if (i + 1 == _attempts) {
        return Err(
          payload: err,
          requestURL: url,
          notifyKind: notify,
          message: message,
        );
      }
    }
  }

  return Err(
    notifyKind: notify,
    message: message,
  );
}

Future<Response> getAny({
  required Uri url,
  Map<String, String>? headers,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.get(url, headers: headers);

  final response = await _makeAny(request, url, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response> postAny({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response = await _makeAny(request, url, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response> putAny({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.put(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response = await _makeAny(request, url, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response> patchAny({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.patch(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response = await _makeAny(request, url, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response> deleteAny({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.delete(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response = await _makeAny(request, url, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}
