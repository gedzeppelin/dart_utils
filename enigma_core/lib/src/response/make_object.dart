part of "response.dart";

Future<Response<T>> _makeObject<T>(
  RequestOptions request,
  Deserializer<T> deserializer,
  int? attempts,
  NotifyKind? notify,
  String? message,
) async {
  final _attempts = attempts ?? defaults.response.attempts;

  for (var i = 0; i < _attempts; i++) {
    try {
      final dioResponse = await defaults.response.client.fetch(request);

      if (dioResponse.isSuccessful && dioResponse.data != null) {
        final value = deserializer(dioResponse.data as Map<String, dynamic>);

        return Ok(
          value: value,
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
          error: err,
          payload: err.response?.data,
          requestURL: err.response?.realUri ?? request.uri,
          status: err.response?.statusCode,
          notifyKind: notify,
          message: message,
        );
      }
    } catch (err) {
      continue;
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
  required String url,
  required Deserializer<T> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  OnFinally<T>? onFinally,
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

Future<Response<T>> postObject<T>({
  required String url,
  required Deserializer<T> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  OnFinally<T>? onFinally,
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

Future<Response<T>> putObject<T>({
  required String url,
  required Deserializer<T> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  OnFinally<T>? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "PUT";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response =
      await _makeObject(request, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response<T>> patchObject<T>({
  required String url,
  required Deserializer<T> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  OnFinally<T>? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "PATCH";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response =
      await _makeObject(request, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

  return response;
}

Future<Response<T>> deleteObject<T>({
  required String url,
  required Deserializer<T> deserializer,
  Options? options,
  Map<String, dynamic>? queryParameters,
  Object? body,
  int? attempts,
  IfOkFold<T>? ifOk,
  IfErrFold<T>? ifErr,
  OnFinally<T>? onFinally,
  NotifyKind? notify,
  String? message,
}) async {
  options ??= Options();
  options.method = "DELETE";

  final request = options.compose(defaults.response.client.options, url,
      options: options, queryParameters: queryParameters, data: body);

  final response =
      await _makeObject(request, deserializer, attempts, notify, message);

  response.fold(ifOk: ifOk, ifErr: ifErr);
  onFinally?.call(response);

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
