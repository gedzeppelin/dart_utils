part of "response.dart";

/// Builds a [Response] with HTTP"s response status code comparison.
Future<Response<Paginator<T>>> getPaginator<T>({
  required Uri url,
  Map<String, String>? headers,
  required Deserializer<Paginator<T>> deserializer,
  int? attempts,
  IfOkFold<Paginator<T>>? ifOk,
  IfErrFold<Paginator<T>>? ifErr,
  NotifyKind? notify,
  String? message,
}) async {
  final request = options.response.client.get(url, headers: headers);

  final response =
      await _makeObject(request, url, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  return response;
}
/* 
Future<Response<T>> postPaginator<T>({
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
 */
