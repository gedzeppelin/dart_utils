import "package:flutter/material.dart";

class PaginationBottomLoader extends StatelessWidget {
  const PaginationBottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class PaginationFullLoader extends StatelessWidget {
  const PaginationFullLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class PaginationEmpty extends StatelessWidget {
  const PaginationEmpty({this.message, Key? key}) : super(key: key);

  final Text? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: message ?? Text("No existen elementos disponibles"),
      ),
    );
  }
}
