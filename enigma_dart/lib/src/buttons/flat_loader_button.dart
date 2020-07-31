import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef OnLoaderButtonPressed = FutureOr<void> Function(void Function() startLoading, void Function() stopLoading);

class FlatLoaderButton extends StatefulWidget {
  const FlatLoaderButton({
    Key key,
    @required this.child,
    @required this.onTap,
    this.margin = const EdgeInsets.all(8.0),
    this.height = 40.0,
    this.width,
    this.loaderColor,
    this.loaderSize = 30.0,
    this.isAsync = true,
  }) : super(key: key);

  final Widget child;
  final double height;
  final bool isAsync;
  final Color loaderColor;
  final double loaderSize;
  final EdgeInsets margin;
  final OnLoaderButtonPressed onTap;
  final double width;

  @override
  FlatLoaderButtonState createState() => FlatLoaderButtonState();
}

class FlatLoaderButtonState extends State<FlatLoaderButton> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void startLoading() => setState(() => _isLoading = true);
  void stopLoading() => setState(() => _isLoading = false);

  @override
  Widget build(BuildContext context) {
    final child = Visibility(
      visible: !_isLoading,
      child: widget.isAsync
          ? FlatButton(
              onPressed: () async {
                if (!_isLoading) {
                  startLoading();
                  await widget.onTap(startLoading, stopLoading);
                  stopLoading();
                }
              },
              child: widget.child,
            )
          : FlatButton(
              onPressed: () {
                if (!_isLoading) widget.onTap(startLoading, stopLoading);
              },
              child: widget.child,
            ),
      replacement: SpinKitCircle(
        size: widget.loaderSize,
        color: widget.loaderColor ?? Theme.of(context).primaryColor,
      ),
    );

    return widget.width != null
        ? Container(
            margin: widget.margin,
            height: widget.height,
            width: widget.width,
            child: child,
          )
        : Container(
            margin: widget.margin,
            height: widget.height,
            child: child,
          );
  }
}
