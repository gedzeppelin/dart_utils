import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import "common.dart";

class FlatLoaderButton extends StatefulWidget {
  const FlatLoaderButton({
    Key key,
    @required this.child,
    @required this.onTap,
    this.margin,
    this.width,
    this.height = 50.0,
    this.color,
    // Loader.
    this.loaderSize = 25.0,
    this.loaderColor,
  }) : super(key: key);

  final Widget child;
  final OnLoaderButtonPressed onTap;
  final EdgeInsets margin;
  final double width;
  final double height;
  final Color color;

  // Loader properties.
  final double loaderSize;
  final Color loaderColor;

  @override
  FlatLoaderButtonState createState() => FlatLoaderButtonState();
}

class FlatLoaderButtonState extends State<FlatLoaderButton> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void onPressed() {
    if (!_isLoading) {
      widget.onTap(startLoading, stopLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final child = Visibility(
      visible: !_isLoading,
      child: FlatButton(
        child: widget.child,
        onPressed: onPressed,
        color: widget.color,
      ),
      replacement: SpinKitWave(
        size: widget.loaderSize,
        color: widget.loaderColor ?? isLight ? Colors.black : Colors.white,
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
