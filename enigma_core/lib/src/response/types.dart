part of "response.dart";

enum NotifyType { success, error, warning, normal }
enum NotifyKind { always, never, ifOk, ifErr }

typedef Deserializer<T> = T Function(Map<String, dynamic> decodedBody);

typedef IfOkFold<T> = void Function(T payload, Ok<T> ok);
typedef IfErrFold<T> = void Function(Object? e, Err<T> err);

typedef IfOkMap<T, R> = R Function(T payload, Ok<T> ok);
typedef IfErrMap<T, R> = R Function(Object? e, Err<T> err);

typedef OnFinally<T> = void Function(Response<T> res);

class ErrInfo {
  final String property;
  final List<dynamic> errors;

  const ErrInfo(this.property, this.errors);
}

class Notifier {
  void Function(String msg) normal;
  void Function(String msg) success;
  void Function(String msg) error;
  void Function(String msg) warn;

  Notifier(this.normal, this.success, this.error, this.warn);
}
