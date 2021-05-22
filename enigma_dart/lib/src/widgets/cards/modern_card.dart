import 'package:enigma_dart/src/theme/theme.dart';
import "package:flutter/material.dart";

typedef CardBuilder = Widget Function(
  BuildContext context,
  Radius borderRadius,
  Color borderColor,
);

class ModernCard extends StatelessWidget {
  const ModernCard({
    Key? key,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.height,
    this.width,
    this.onTap,
    required this.builder,
    // Border.
    this.borderColor,
    this.borderRadius = 8.0,
    this.borderWidth = 2.0,
    // Shadow.
    this.shadowColor = const Color(0xffB3A8A7),
    this.shadowOffset = const Offset(4.0, 4.0),
  }) : super(key: key);

  // Main properties.
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  final void Function()? onTap;
  final CardBuilder builder;

  // Border properties.
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;

  // Shadow properties.
  final Color shadowColor;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);
    final _borderColor = borderColor ?? (light ? Colors.black : Colors.white);

    return Container(
      margin: margin,
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor,
            offset: shadowOffset,
          )
        ],
      ),
      child: Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: _borderColor,
            width: borderWidth,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: Builder(
              builder: (context) => builder(
                context,
                Radius.circular(borderRadius),
                _borderColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
