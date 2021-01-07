part of 'response.dart';

Future<Either<http.Response, ErrMultiple<T>>> _makeAttempts<T>(
  Future<http.Response> httpRequest,
  int attempts,
) async {
  final List<ErrInternal<T>> errors = List();

  for (var i = 0; i < attempts; i++) {
    try {
      final response = await httpRequest;
      return Left(response);
    } catch (e, s) {
      final errorUtil = ErrInternal<T>(e, s);
      errors.add(errorUtil);
    }
  }

  return Right(
    ErrMultiple<T>(IList.from(errors)),
  );
}

// ANCHOR Request helpers.

/// Builds a [Response] with HTTP"s response status code comparison.
Future<Response<T>> makeRequest<T extends Object>({
  @required Future<http.Response> httpRequest,
  @required Deserializer<T> deserializer,
  int attempts = Response.defaultAttempts,
}) async {
  final result = await _makeAttempts<T>(httpRequest, attempts);

  return result.fold(
    (response) {
      try {
        final decodedBody = json.decode(response.body) as Map<String, dynamic>;

        if (response.isSuccessful) {
          final payload = deserializer(decodedBody);
          return Ok<T>(payload);
        }

        return ErrExternal<T>(response);
      } catch (e, s) {
        return ErrInternal<T>(e, s);
      }
    },
    (err) => err,
  );
}

/// Builds a [Response] with HTTP"s response status code comparison.
Future<Response<P>> makePaginatedRequest<P extends Paginated>({
  @required Future<http.Response> httpRequest,
  @required Deserializer<P> deserializer,
  int attempts = Response.defaultAttempts,
}) async {
  final result = await _makeAttempts<P>(httpRequest, attempts);

  return result.fold(
    (response) {
      try {
        final decodedBody = json.decode(response.body) as Map<String, dynamic>;
        //decodedBody[injectedUrlKey] = response.request.url.toString();

        if (response.isSuccessful) {
          final payload = deserializer(decodedBody);
          return Ok<P>(payload);
        }

        return ErrExternal<P>(response);
      } catch (e, s) {
        return ErrInternal<P>(e, s);
      }
    },
    (err) => err,
  );
}

/// Builds a [Response] with HTTP"s response status code comparison.
Future<Response<L>> makeListRequest<T, L extends List<T>>({
  @required Future<http.Response> httpRequest,
  @required Deserializer<T> deserializer,
  int attempts = Response.defaultAttempts,
}) async {
  try {
    final result = await _makeAttempts<L>(httpRequest, attempts);

    return result.fold(
      (response) {
        try {
          final decodedBody = json.decode(response.body) as Iterable<dynamic>;
          //decodedBody[injectedUrlKey] = response.request.url.toString();

          if (response.isSuccessful) {
            final payload = decodedBody
                ?.map(
                  (item) => item == null ? null : deserializer(item),
                )
                ?.toList();
            return Ok<L>(payload);
          }

          return ErrExternal<L>(response);
        } catch (e, s) {
          return ErrInternal<L>(e, s);
        }
      },
      (err) => err,
    );
  } on Exception catch (e, s) {
    return ErrInternal<L>(e, s);
  }
}

///
Future<bool> checkRequestSuccess(
  Future<http.Response> httpRequest, {
  int attempts = Response.defaultAttempts,
}) async {
  final result = await _makeAttempts(httpRequest, attempts);
  return result.fold((r) => r.isSuccessful, (_) => false);
}

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
      : Response.errMultiple(IList.from(responses.whereType<Err>()), 2);
}

Future<Response<Tuple3<T, S, U>>> waitResponses3<T, S, U>(
  Future<Response<T>> future0,
  Future<Response<S>> future1,
  Future<Response<U>> future2,
) async {
  final responses = await Future.wait([future0, future1, future2]);

  final response0 = responses[0] as Response<T>;
  final response1 = responses[1] as Response<S>;
  final response2 = responses[2] as Response<U>;

  return response0 is Ok<T> && response1 is Ok<S> && response2 is Ok<U>
      ? Response.ok(Tuple3(
          response0.payload,
          response1.payload,
          response2.payload,
        ))
      : Response.errMultiple(IList.from(responses.whereType<Err>()), 3);
}

Future<Response<Tuple4<T, S, U, V>>> waitResponses4<T, S, U, V>(
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

  return response0 is Ok<T> && response1 is Ok<S> && response2 is Ok<U> && response3 is Ok<V>
      ? Response.ok(Tuple4(
          response0.payload,
          response1.payload,
          response2.payload,
          response3.payload,
        ))
      : Response.errMultiple(IList.from(responses.whereType<Err>()), 4);
}

Future<Response<Tuple5<T, S, U, V, W>>> waitResponses5<T, S, U, V, W>(
  Future<Response<T>> future0,
  Future<Response<S>> future1,
  Future<Response<U>> future2,
  Future<Response<V>> future3,
  Future<Response<W>> future4,
) async {
  final responses = await Future.wait([future0, future1, future2, future3, future4]);

  final response0 = responses[0] as Response<T>;
  final response1 = responses[1] as Response<S>;
  final response2 = responses[2] as Response<U>;
  final response3 = responses[3] as Response<V>;
  final response4 = responses[4] as Response<W>;

  return response0 is Ok<T> && response1 is Ok<S> && response2 is Ok<U> && response3 is Ok<V> && response4 is Ok<W>
      ? Response.ok(Tuple5(
          response0.payload,
          response1.payload,
          response2.payload,
          response3.payload,
          response4.payload,
        ))
      : Response.errMultiple(IList.from(responses.whereType<Err>()), 5);
}

Future<Response<List<T>>> waitAll<T>(List<Future<Response<T>>> futures) async {
  final responses = await Future.wait(futures);
  final result = List<T>();

  for (final item in responses) {
    if (item is Err<T>) {
      return item.toType();
    }

    if (item is Ok<T>) {
      result.add(item.payload);
    }
  }

  return Ok(result);
}
