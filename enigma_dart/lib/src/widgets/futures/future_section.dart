import "package:enigma_core/enigma_core.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import 'types.dart';

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
  }) : super(key: key);

  final OkBuilder<T> builder;
  final ErrBuilder<T>? errorBuilder;
  final FutureCallback<T> futureCallback;
  final WidgetBuilder? loaderBuilder;
  final Color loaderColor;
  final EdgeInsets loaderPadding;
  final double loaderSize;

  @override
  FutureSectionState<T> createState() => FutureSectionState<T>();
}

class FutureSectionState<T> extends State<FutureSection<T>> {
  late Future<Response<T>> _futureResponse;

  @override
  void initState() {
    super.initState();
    // Fetch the future data on initiation.
    _futureResponse = widget.futureCallback();
  }

  Future<Response<T>> refresh() {
    setState(() {
      _futureResponse = widget.futureCallback();
    });

    return _futureResponse;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<T>>(
      future: _futureResponse,
      builder: (BuildContext context, AsyncSnapshot<Response<T>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.map(
            ifOk: (value, ok) => widget.builder(context, value, ok),
            ifErr: (e, err) =>
                widget.errorBuilder?.call(context, err, refresh) ??
                makeRetryWidget(refresh, err),
          );
        } else if (snapshot.hasError) {
          final err = Err<T>(payload: snapshot.error);
          return widget.errorBuilder?.call(context, err, refresh) ??
              makeRetryWidget(refresh, err);
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
