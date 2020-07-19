import 'package:enigma_flutter/src/buttons/flat_loader_button.dart';
import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    Key key,
    @required this.onTap,
    this.errorWidget,
    this.exception,
  }) : super(key: key);

  final Widget errorWidget;
  final Exception exception;
  final OnLoaderButtonPressed onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: 16.0,
              right: 16.0,
              bottom: 4.0,
              left: 16.0,
            ),
            child: errorWidget ??
                Text(
                  exception == null ? 'Ocurrió un error al procesar su operación' : exception.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
          ),
          FlatLoaderButton(
            child: Text(
              'REINTENTAR',
              style: TextStyle(fontSize: 16.0),
            ),
            onTap: onTap,
            isAsync: false,
            margin: const EdgeInsets.only(
              top: 4.0,
              right: 16.0,
              bottom: 16.0,
              left: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
