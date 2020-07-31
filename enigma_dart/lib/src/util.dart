import 'package:flutter/material.dart';

typedef OnPressed = void Function();

const String _snackbarError = 'Ocurrió un error, inténtelo nuevamente';

extension MapUtilList<T> on List<T> {
  List<E> mapWidget<E extends Widget>(E Function(T item) fn) {
    return this.map<E>(fn).toList();
  }

  List<E> mapList<E>(E Function(T item) fn) {
    return this.map<E>(fn).toList();
  }
}

extension ContextSnackbar on BuildContext {
  void snackbar({
    bool action = true,
    String actionMsg = 'Cerrar',
    String mg = _snackbarError,
    void Function() onPressed,
  }) {
    final SnackBarAction snackbarAction = action
        ? SnackBarAction(
            label: actionMsg,
            onPressed: onPressed != null
                ? () {
                    Scaffold.of(this).hideCurrentSnackBar();
                    onPressed();
                  }
                : () => Scaffold.of(this).hideCurrentSnackBar(),
          )
        : null;
    final SnackBar snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(mg),
      action: snackbarAction,
    );
    Scaffold.of(this).hideCurrentSnackBar();
    Scaffold.of(this).showSnackBar(snackbar);
  }
}

extension ScaffoldSnackbar on GlobalKey<ScaffoldState> {
  void snackbar({
    bool action = true,
    String actionMsg = 'Cerrar',
    String mg = _snackbarError,
    void Function() onPressed,
  }) {
    final SnackBarAction snackbarAction = action
        ? SnackBarAction(
            label: actionMsg,
            onPressed: onPressed != null
                ? () {
                    this.currentState.hideCurrentSnackBar();
                    onPressed();
                  }
                : () => this.currentState.hideCurrentSnackBar(),
          )
        : null;
    final SnackBar snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(mg),
      action: snackbarAction,
    );
    this.currentState.hideCurrentSnackBar();
    this.currentState.showSnackBar(snackbar);
  }
}
