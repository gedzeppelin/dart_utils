part of "response.dart";

enum NotifyType { success, error, warning }
enum NotifyKinds { always, never, ifOk, ifErr }

typedef Deserializer<T> = T Function(Map<String, dynamic> decodedBody);

typedef IfOkFold<T> = void Function(Ok<T> ok);
typedef IfErrFold<T> = void Function(Err<T> err);

typedef IfOkMap<T, R> = R Function(Ok<T> ok);
typedef IfErrMap<T, R> = R Function(Err<T> err);

class ErrInfo {
  final String property;
  final List<dynamic> errors;

  const ErrInfo(this.property, this.errors);
}

class Notifier {
  void Function(String msg) success;
  void Function(String msg) error;
  void Function(String msg) warn;

  Notifier(this.success, this.error, this.warn);
}
