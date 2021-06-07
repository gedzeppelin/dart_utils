part of "response.dart";

Future<Response> _makeAny(
  RequestOptions request,
  int? attempts,
  NotifyKind? notify,
  String? message,
) async {
  final _attempts = attempts ?? defaults.response.attempts;

  for (var i = 0; i < _attempts; i++) {
    try {
      final dioResponse = await defaults.response.client.fetch(request);

      if (dioResponse.isSuccessful) {
        return Ok(
          value: dioResponse.data,
          requestURL: dioResponse.realUri,
          status: dioResponse.statusCode,
          notifyKind: notify,
          message: message,
        );
      } else if (i + 1 == _attempts) {
        return Err(
          payload: dioResponse.data,
          requestURL: dioResponse.realUri,
          status: dioResponse.statusCode,
          notifyKind: notify,
          message: message,
        );
      }
    } on DioError catch (err) {
      if (i + 1 == _attempts) {
        return Err(
          payload: err.response?.data,
          requestURL: request.uri,
          notifyKind: notify,
          message: message,
        );
      }
    } catch (err) {
      continue;
    }
  }

  return Err(
    notifyKind: notify,
    message: message,
  );
}

Future<Response> getAny({
  required String url,
  Options? options,
  Map<String, dynamic>? queryParameters,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  OnFinally? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "GET";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters);

  final response = await _makeAny(request, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response> postAny({
  required String url,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  OnFinally? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "POST";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response = await _makeAny(request, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response> putAny({
  required String url,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  OnFinally? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "PUT";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response = await _makeAny(request, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response> patchAny({
  required String url,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  OnFinally? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "PATCH";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response = await _makeAny(request, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response> deleteAny({
  required String url,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold? ifOk,
  IfErrFold? ifErr,
  OnFinally? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "DELETE";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response = await _makeAny(request, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}
