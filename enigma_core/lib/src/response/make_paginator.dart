part of "response.dart";

/// Builds a [Response] with HTTP"s response status code comparison.
Future<Response<Paginator<T>>> getPaginator<T>({
  required String url,
  required Deserializer<Paginator<T>> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold<Paginator<T>>? ifOk,
  IfErrFold<Paginator<T>>? ifErr,
  OnFinally<Paginator<T>>? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "POST";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response =
      await _makeObject(request, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

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
