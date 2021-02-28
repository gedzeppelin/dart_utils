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
    @required this.value,
    this.onAddPressed,
    this.onRemovePressed,
    this.isEnabled = true,
  }) : super(key: key);

  final int value;
  final OnMutation onAddPressed;
  final OnMutation onRemovePressed;
  final bool isEnabled;

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
    if (_quantity == null) _quantity = widget.value;
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
    final isLight = Theme.of(context).brightness == Brightness.light;

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
              onTap: widget.isEnabled
                  ? () async {
                      if (widget.onRemovePressed != null) {
                        setState(() => _isRemoving = true);
                        await widget.onRemovePressed(_quantity, setQuantity);
                        setState(() => _isRemoving = false);
                      }
                    }
                  : null,
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.remove,
                  size: 16.0,
                  color: widget.isEnabled
                      ? isLight
                          ? Colors.black
                          : Colors.white
                      : Colors.grey,
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
              onTap: widget.isEnabled
                  ? () async {
                      if (widget.onAddPressed != null) {
                        setState(() => _isAdding = true);
                        await widget.onAddPressed(_quantity, setQuantity);
                        setState(() => _isAdding = false);
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.add,
                  size: 16.0,
                  color: widget.isEnabled
                      ? isLight
                          ? Colors.black
                          : Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
