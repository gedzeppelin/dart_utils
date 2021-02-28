import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import "common.dart";

class RaisedLoaderButton extends StatefulWidget {
  const RaisedLoaderButton({
    Key key,
    @required this.child,
    @required this.onTap,
    this.margin,
    this.width = 250.0,
    this.height = 50.0,
    this.color,
    this.radius = 8.0,
    // Loader.
    this.loaderSize = 25.0,
    this.loaderColor,
    // Border.
    this.borderColor,
    this.borderWidth = 2.0,
    // Shadow.
    this.shadowColor,
    this.shadowOffset = const Offset(4.0, 4.0),
  }) : super(key: key);

  final Widget child;
  final OnLoaderButtonPressed onTap;
  final EdgeInsets margin;
  final double width;
  final double height;
  final Color color;
  final double radius;

  // Loader properties.
  final double loaderSize;
  final Color loaderColor;

  // Border properties.
  final Color borderColor;
  final double borderWidth;

  // Shadow properties.
  final Color shadowColor;
  final Offset shadowOffset;

  @override
  RaisedLoaderButtonState createState() => RaisedLoaderButtonState();
}

class RaisedLoaderButtonState extends State<RaisedLoaderButton> {
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

    if (isLight) {
      return Container(
        margin: widget.margin,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: widget.shadowColor ?? const Color(0xffB3A8A7),
              offset: widget.shadowOffset,
            )
          ],
        ),
        child: RaisedButton(
          elevation: 0.0,
          color: widget.color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(widget.radius),
            side: BorderSide(
              color: widget.borderColor ?? Colors.black,
              width: widget.borderWidth,
            ),
          ),
          child: Visibility(
            visible: !_isLoading,
            child: DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.50,
                  ),
              child: widget.child,
            ),
            replacement: SpinKitWave(
              size: widget.loaderSize,
              color: widget.loaderColor ?? Colors.black,
            ),
          ),
          onPressed: onPressed,
        ),
      );
    }

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: widget.shadowOffset.dy,
          left: widget.shadowOffset.dx,
          child: Container(
            margin: widget.margin,
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color: widget.borderColor ?? Colors.white,
                width: widget.borderWidth,
              ),
            ),
          ),
        ),
        Container(
          margin: widget.margin,
          height: widget.height,
          width: widget.width,
          child: RaisedButton(
            elevation: 0.0,
            splashColor: Colors.white54,
            color: widget.color ?? Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(widget.radius),
              side: BorderSide(
                color: widget.borderColor ?? Colors.white,
                width: widget.borderWidth,
              ),
            ),
            child: Visibility(
              visible: !_isLoading,
              child: DefaultTextStyle(
                style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.50,
                    ),
                child: widget.child,
              ),
              replacement: SpinKitWave(
                size: widget.loaderSize,
                color: widget.loaderColor ?? Colors.white,
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
