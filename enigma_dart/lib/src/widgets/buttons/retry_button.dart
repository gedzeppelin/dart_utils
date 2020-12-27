import "package:flutter/material.dart";

import "flat_loader_button.dart";
import "util.dart";

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    Key key,
    @required this.onTap,
    this.messageWidget,
    this.message,
  }) : super(key: key);

  final Widget messageWidget;
  final String message;
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
            child: messageWidget ??
                Text(
                  message == null ? "Ocurrió un error al procesar su operación" : message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
          ),
          FlatLoaderButton(
            child: Text(
              "REINTENTAR",
              style: TextStyle(fontSize: 16.0),
            ),
            onTap: onTap,
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
