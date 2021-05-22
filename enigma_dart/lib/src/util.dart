import "package:flutter/material.dart";

typedef OnPressed = void Function();
typedef OnValueChange<T> = void Function(T value);

extension ListExtension<T> on Iterable<T> {
  List<E> mapWidget<E extends Widget>(E Function(T x) fn) {
    return this.map<E>(fn).toList();
  }

  List<E> mapList<E>(E Function(T x) fn) {
    return this.map<E>(fn).toList();
  }
}

/* class SizedProgressIndicator extends StatelessWidget {
  const SizedProgressIndicator({
    Key key,
    this.boxSize,
    this.size = 25.0,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  final double boxSize;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
      ),
    );

    if (boxSize != null) {
      return Center(
        child: SizedBox(
          width: boxSize ?? size,
          height: boxSize ?? size,
          child: loader,
        ),
      );
    }

    return Center(child: loader);
  }
}
 */
