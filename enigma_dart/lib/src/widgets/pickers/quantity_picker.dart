import "dart:async";

import "package:flutter/material.dart";

typedef QuantitySetter = void Function(int newQuantity);
typedef OnMutation = FutureOr<void> Function(
  int quantity,
  QuantitySetter setQuantity,
);

class QuantityPicker extends StatefulWidget {
  const QuantityPicker({
    Key key,
    @required this.initialValue,
    this.onAddPressed,
    this.onRemovePressed,
  }) : super(key: key);

  final int initialValue;
  final OnMutation onAddPressed;
  final OnMutation onRemovePressed;

  @override
  _QuantityPickerState createState() => _QuantityPickerState();
}

class _QuantityPickerState extends State<QuantityPicker> {
  bool _isAdding = false;
  bool _isRemoving = false;
  int _quantity;

  @override
  void initState() {
    super.initState();
    if (_quantity == null) _quantity = widget.initialValue;
  }

  void setQuantity(int newQuantity) {
    if (newQuantity != null && newQuantity > 0) {
      setState(() {
        _quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.0,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // ANCHOR Remove one.
          Visibility(
            visible: !_isRemoving,
            replacement: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
            child: InkWell(
              onTap: () async {
                if (widget.onRemovePressed != null) {
                  setState(() => _isRemoving = true);
                  await widget.onRemovePressed(_quantity, setQuantity);
                  setState(() => _isRemoving = false);
                }
              },
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.remove,
                  size: 16.0,
                ),
              ),
            ),
          ),
          // ANCHOR Quantity text.
          Text("$_quantity"),
          // ANCHOR Add one.
          Visibility(
            visible: !_isAdding,
            replacement: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () async {
                if (widget.onAddPressed != null) {
                  setState(() => _isAdding = true);
                  await widget.onAddPressed(_quantity, setQuantity);
                  setState(() => _isAdding = false);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.add,
                  size: 16.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
