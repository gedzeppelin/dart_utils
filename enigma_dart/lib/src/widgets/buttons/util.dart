import 'dart:async';

typedef OnLoaderButtonPressed = FutureOr<void> Function(void Function() startLoading, void Function() stopLoading);
