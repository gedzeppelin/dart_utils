part of "response.dart";

Future<Response<T>> _makeObject<T>(
  Future<http.Response> httpRequest,
  Uri url,
  Deserializer<T> deserializer,
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
        final body = json.decode(stringBody) as Map<String, dynamic>;
        final payload = deserializer(body);

        return Ok(
          payload: payload,
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

  return Err<T>(
    notifyKind: notify,
    message: message,
  );
}

// ANCHOR Request helpers.

/// Builds a [Response] with HTTP"s response status code comparison.
Future<Response<T>> getObject<T>({
  required Uri url,
  Map<String, String>? headers,
  required Deserializer<T> deserializer,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.get(url, headers: headers);

  final response =
      await _makeObject(request, url, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response<T>> postObject<T>({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  required Deserializer<T> deserializer,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.post(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response =
      await _makeObject(request, url, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response<T>> putObject<T>({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  required Deserializer<T> deserializer,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.put(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response =
      await _makeObject(request, url, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response<T>> patchObject<T>({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  required Deserializer<T> deserializer,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.patch(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response =
      await _makeObject(request, url, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

Future<Response<T>> deleteObject<T>({
  required Uri url,
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  required Deserializer<T> deserializer,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.delete(
    url,
    headers: headers,
    body: body,
    encoding: encoding,
  );

  final response =
      await _makeObject(request, url, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}

/*

// ANCHOR Multiple request helpers.

Future<Response<Tuple2<T, S>>> waitResponses2<T, S>(
  Future<Response<T>> future0,
  Future<Response<S>> future1,
) async {
  final responses = await Future.wait([future0, future1]);

  final response0 = responses[0] as Response<T>;
  final response1 = responses[1] as Response<S>;

  return response0 is Ok<T> && response1 is Ok<S>
      ? Response.ok(Tuple2(
          response0.payload,
          response1.payload,
        ))
      : Response.errMultiple(responses.whereType<Err>(), 2);
}

 */
