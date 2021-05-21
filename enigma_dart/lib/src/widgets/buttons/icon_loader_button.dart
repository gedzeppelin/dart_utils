import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import "common.dart";

class IconLoaderButton extends StatefulWidget {
  const IconLoaderButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.margin,
    this.boxSize = 24.0,
    this.iconSize = 24.0,
    this.color,
    this.enabled = true,
    // Loader.
    this.loaderSize,
    this.loaderColor,
  }) : super(key: key);

  final Icon icon;
  final OnLoaderButtonPressed onTap;
  final EdgeInsets? margin;
  final double boxSize;
  final double iconSize;
  final Color? color;

  final bool enabled;

  // Loader properties.
  final double? loaderSize;
  final Color? loaderColor;

  @override
  IconLoaderButtonState createState() => IconLoaderButtonState();
}

class IconLoaderButtonState extends State<IconLoaderButton> {
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
    final btnColor = widget.loaderColor ?? Theme.of(context).primaryColor;

    final visibility = IconButton(
      icon: Visibility(
        visible: !_isLoading,
        child: widget.icon,
        replacement: SpinKitRing(
          lineWidth: 2.0,
          size: widget.loaderSize ?? widget.iconSize,
          color: widget.loaderColor ?? btnColor,
        ),
      ),
      iconSize: widget.iconSize,
      onPressed: widget.enabled ? onPressed : null,
      color: widget.color ?? btnColor,
    );

    if (widget.margin != null) {
      return Container(
        margin: widget.margin,
        height: widget.boxSize,
        width: widget.boxSize,
        child: visibility,
      );
    }

    return visibility;
  }
}
