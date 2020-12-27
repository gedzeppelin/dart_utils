import "package:flutter/material.dart";

import "enigma_text_field.dart";

typedef Widget FormBuilder(BuildContext context, List<EnigmaTextField> formItems);

class EnigmaForm extends StatefulWidget {
  EnigmaForm({
    Key key,
    @required this.formItems,
    this.formBuilder,
    this.isExpanded = true,
    this.isScrollable = true,
    this.padding,
  }) : super(key: key);

  final FormBuilder formBuilder;
  final EdgeInsets padding;
  final bool isExpanded;
  final bool isScrollable;
  final List<EnigmaTextField> formItems;

  @override
  EnigmaFormState createState() => EnigmaFormState();
}

class EnigmaFormState extends State<EnigmaForm> {
  List<FocusNode> focusNodeList;
  List<EnigmaTextField> formItems;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    focusNodeList.forEach((fn) => fn.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final nodeSize = widget.formItems.length;

    // Generate a FocusNode for each form text field.
    focusNodeList = List<FocusNode>.generate(
      nodeSize,
      (_) => FocusNode(),
    );
    formItems = List<EnigmaTextField>.generate(
      nodeSize,
      (int idx) => widget.formItems[idx].copyWith(
        focusNode: focusNodeList[idx],
        nextNode: idx < nodeSize - 1 ? focusNodeList[idx + 1] : null,
      ),
    );
  }

  bool get isValid => formKey.currentState.validate();

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: formKey,
      child: widget.formBuilder != null ? widget.formBuilder(context, formItems) : Column(children: formItems),
    );

    final body = widget.isScrollable
        ? SingleChildScrollView(
            padding: widget.padding ?? const EdgeInsets.all(16.0),
            child: form,
          )
        : Padding(
            padding: widget.padding ?? const EdgeInsets.all(16.0),
            child: form,
          );

    return widget.isExpanded ? Expanded(child: body) : body;
  }
}
