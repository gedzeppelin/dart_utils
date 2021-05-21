import "package:flutter/material.dart";
import "package:enigma_dart/src/util.dart";

class RadioDialog<T> extends StatefulWidget {
  RadioDialog({
    Key? key,
    this.title,
    required this.values,
    required this.selected,
    this.onChange,
  }) : super(key: key);

  final Widget? title;
  final T selected;
  final Map<T, Widget> values;
  final OnValueChange<T>? onChange;

  @override
  _RadioDialogState<T> createState() => _RadioDialogState<T>();
}

class _RadioDialogState<T> extends State<RadioDialog<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: widget.title,
      children: widget.values.entries
          .map(
            (e) => RadioListTile<T>(
              title: e.value,
              value: e.key,
              groupValue: _selected,
              onChanged: (T? value) {
                if (value != null) {
                  setState(() {
                    _selected = value;
                  });

                  widget.onChange?.call(value);
                }
              },
            ),
          )
          .toList(),
    );
  }
}
