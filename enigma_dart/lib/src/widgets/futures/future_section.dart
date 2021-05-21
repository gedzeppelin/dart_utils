import "package:enigma_core/enigma_core.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import "util.dart";

class RefreshNotification extends Notification {
  const RefreshNotification();
}

class FutureSection<T> extends StatefulWidget {
  FutureSection({
    Key? key,
    required this.futureCallback,
    required this.builder,
    this.errorBuilder,
    this.loaderBuilder,
    this.loaderColor = Colors.blue,
    this.loaderPadding = const EdgeInsets.all(16.0),
    this.loaderSize = 25.0,
    this.onResolve,
  }) : super(key: key);

  final SuccessBuilder<T> builder;
  final ErrorBuilder<T>? errorBuilder;
  final FutureCallback<T> futureCallback;
  final WidgetBuilder? loaderBuilder;
  final Color loaderColor;
  final EdgeInsets loaderPadding;
  final double loaderSize;
  final OnResolve<T>? onResolve;

  @override
  FutureSectionState<T> createState() => FutureSectionState<T>();
}

class FutureSectionState<T> extends State<FutureSection<T>> {
  late Future<Response<T>> _futureData;

  @override
  void initState() {
    super.initState();
    // Fetch the future data on initiation.
    _futureData = widget.futureCallback();

    // On resolve method.
    final _onResolve = widget.onResolve;
    if (_onResolve != null) {
      _futureData.attachOnSuccess(_onResolve);
    }
  }

  Future<Response<T>> refresh() {
    setState(() {
      _futureData = widget.futureCallback();
    });

    // On resolve method.
    final _onResolve = widget.onResolve;
    if (_onResolve != null) {
      _futureData.attachOnSuccess(_onResolve);
    }

    return _futureData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<T>>(
      future: _futureData,
      builder: (BuildContext context, AsyncSnapshot<Response<T>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.map(
            ifOk: (ok) => widget.builder(context, ok.payload),
            ifErr: (err) {
              final retryWidget = makeRetryWidget(refresh, err);
              return widget.errorBuilder?.call(context, refresh, err) ??
                  retryWidget;
            },
          );
        } else if (snapshot.hasError) {
          final err = Err<T>(payload: snapshot.error);
          final retryWidget = makeRetryWidget(refresh, err);

          return widget.errorBuilder?.call(context, refresh, err) ??
              retryWidget;
        }

        return widget.loaderBuilder?.call(context) ??
            Padding(
              padding: widget.loaderPadding,
              child: SpinKitRing(
                lineWidth: 2.0,
                color: widget.loaderColor,
                size: widget.loaderSize,
              ),
            );
      },
    );
  }
}
