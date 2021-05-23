part of "response.dart";

Future<Response<Paginator<T>>> getPaginator<T>({
  required String url,
  required Deserializer<Paginator<T>> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  int? attempts,
  IfOkFold<Paginator<T>>? ifOk,
  IfErrFold<Paginator<T>>? ifErr,
  OnFinally<Paginator<T>>? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "GET";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters);

  final response =
      await _makeObject(request, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response<Paginator<T>>> postPaginator<T>({
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
