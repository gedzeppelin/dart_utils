import "package:flutter/material.dart";

typedef OnPressed = void Function();
typedef OnValueChange<T> = void Function(T value);

extension ListExtension<T> on Iterable<T> {
  List<E> mapWidget<E extends Widget>(E Function(T item) fn) {
    return this.map<E>(fn).toList();
  }

  List<E> mapList<E>(E Function(T item) fn) {
    return this.map<E>(fn).toList();
  }
}
