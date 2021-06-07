part of "response.dart";

Err<T> _findError<T>(List<Response> errs) {
  for (final err in errs) {
    if (err is Err) {
      return err as Err<T>;
    }
  }

  return Err();
}

class Ok2<T, S> {
  final Ok<T> ok1;
  final Ok<S> ok2;

  T get p1 => ok1.value;
  S get p2 => ok2.value;

  const Ok2(this.ok1, this.ok2);
}

class Ok3<T, S, R> {
  final Ok<T> ok1;
  final Ok<S> ok2;
  final Ok<R> ok3;

  T get p1 => ok1.value;
  S get p2 => ok2.value;
  R get p3 => ok3.value;

  const Ok3(this.ok1, this.ok2, this.ok3);
}

class Ok4<T, S, R, V> {
  final Ok<T> ok1;
  final Ok<S> ok2;
  final Ok<R> ok3;
  final Ok<V> ok4;

  T get p1 => ok1.value;
  S get p2 => ok2.value;
  R get p3 => ok3.value;
  V get p4 => ok4.value;

  const Ok4(this.ok1, this.ok2, this.ok3, this.ok4);
}

Future<Response<Ok2<T, S>>> multiple2<T, S>(
  Future<Response<T>> future1,
  Future<Response<S>> future2,
) async {
  final responses = await Future.wait([future1, future2]);

  final response0 = responses[0] as Response<T>;
  final response1 = responses[1] as Response<S>;

  return response0 is Ok<T> && response1 is Ok<S>
      ? Ok(value: Ok2(response0, response1))
      : _findError(responses);
}

Future<Response<Ok3<T, S, R>>> multiple3<T, S, R>(
  Future<Response<T>> future1,
  Future<Response<S>> future2,
  Future<Response<R>> future3,
) async {
  final responses = await Future.wait([future1, future2, future3]);

  final response0 = responses[0] as Response<T>;
  final response1 = responses[1] as Response<S>;
  final response2 = responses[2] as Response<R>;

  return response0 is Ok<T> && response1 is Ok<S> && response2 is Ok<R>
      ? Ok(value: Ok3(response0, response1, response2))
      : _findError(responses);
}

Future<Response<Ok4<T, S, R, V>>> multiple4<T, S, R, V>(
  Future<Response<T>> future1,
  Future<Response<S>> future2,
  Future<Response<R>> future3,
  Future<Response<V>> future4,
) async {
  final responses = await Future.wait([future1, future2, future3, future4]);

  final response0 = responses[0] as Response<T>;
  final response1 = responses[1] as Response<S>;
  final response2 = responses[2] as Response<R>;
  final response3 = responses[3] as Response<V>;

  return response0 is Ok<T> &&
          response1 is Ok<S> &&
          response2 is Ok<R> &&
          response3 is Ok<V>
      ? Ok(value: Ok4(response0, response1, response2, response3))
      : _findError(responses);
}
