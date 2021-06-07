import "package:enigma_annotation/enigma_annotation.dart";
import "package:enigma_core/enigma_core.dart";
import "package:flutter/material.dart";

import "package:enigma_dart/src/widgets/buttons/retry_button.dart";

typedef FutureCallback<T> = Future<Response<T>> Function();

typedef OkBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  Ok<T> ok,
);

typedef ErrBuilder<T> = Widget Function(
  BuildContext context,
  Err<T> err,
  Future<Response<T>> Function() refresh,
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

typedef PaginatorCallback<T> = Future<Response<Paginator<T>>> Function(
    int page);

typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);
typedef SeparatorBuilder = Widget Function(BuildContext context, int index);
typedef ErrorBuilder<T> = Widget Function(
    Err<Paginator<T>> error, void Function() refresh);
