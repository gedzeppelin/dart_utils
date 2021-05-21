import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "flat_loader_button.dart";
import "common.dart";

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    Key? key,
    required this.onTap,
    this.message,
    this.err,
  }) : super(key: key);

  final String? message;
  final Exception? err;
  final OnLoaderButtonPressed onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    top: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                    left: 16.0,
                  ),
                  child: Text(
                    message ??
                        (kDebugMode
                            ? err != null
                                ? err.toString()
                                : "Ocurrió un error al procesar su operación"
                            : "Ocurrió un error al procesar su operación, compruebe su conexión a internet"),
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
          ),
        ),
      ),
    );
  }
}
