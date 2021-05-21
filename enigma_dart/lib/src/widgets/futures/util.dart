import "package:enigma_core/enigma_core.dart";
import "package:flutter/material.dart";

import "package:enigma_dart/src/widgets/buttons/retry_button.dart";

typedef FutureCallback<T> = Future<Response<T>> Function();
typedef OnResolve<T> = void Function(T resolved);
typedef SuccessBuilder<T> = Widget Function(BuildContext context, T payload);
typedef ErrorBuilder<T> = Widget Function(
  BuildContext context,
  Future<Response<T>> Function() refresh,
  Err<T> failedResponse,
);

RetryWidget makeRetryWidget<T>(FutureCallback<T> retry, Err<T> failed) {
  return RetryWidget(
    err: failed,
    onTap: (startLoading, stopLoading) {
      startLoading();
      retry().whenComplete(() => stopLoading());
    },
  );
}

extension FutureWidgetUtil<T> on Future<Response<T>> {
  Future<Response<T>> attachOnSuccess(OnResolve<T> onResolve) {
    if (onResolve != null) {
      this.then((Response<T> resolved) {
        if (resolved is Ok<T>) onResolve(resolved.payload);
      });
    }

    return this;
  }
}
