import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:enigma_core/enigma_core.dart";

typedef void OnSubmit(String value, FocusNode focusNode);
typedef void OnFocusChange(bool hasFocus);
typedef String? Validator(String? value);

class EnigmaTextField extends StatefulWidget {
  static const String emailRegex =
      r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+";

  EnigmaTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.formatters,
    this.hint,
    this.initialValue,
    this.inputAction,
    this.inputType,
    this.isPassword = false,
    this.label,
    this.margin,
    this.maxLength,
    this.nextNode,
    this.onFocusChange,
    this.onSubmit,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  }) : super(key: key);

  static const String emailValidationMessage = "Correo inválido";
  static const String emptyValidationMessage = "Campo obligatorio";

  final EdgeInsets? margin;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final List<TextInputFormatter>? formatters;
  final OnFocusChange? onFocusChange;
  final OnSubmit? onSubmit;
  final String? hint;
  final String? initialValue;
  final String? label;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final Validator? validator;
  final bool isPassword;
  final int? maxLength;

  @override
  _EnigmaTextFieldState createState() => _EnigmaTextFieldState();

  EnigmaTextField copyWith({
    Key? key,
    final EdgeInsets? margin,
    final FocusNode? focusNode,
    final FocusNode? nextNode,
    final List<TextInputFormatter>? formatters,
    final OnFocusChange? onFocusChange,
    final OnSubmit? onSubmit,
    final String? hint,
    final String? initialValue,
    final String? label,
    final TextCapitalization? textCapitalization,
    final TextEditingController? controller,
    final TextInputAction? inputAction,
    final TextInputType? inputType,
    final Validator? validator,
    final bool? isPassword,
    final int? maxLength,
  }) {
    return EnigmaTextField(
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      formatters: formatters ?? this.formatters,
      hint: hint ?? this.hint,
      initialValue: initialValue ?? this.initialValue,
      inputAction: inputAction ?? this.inputAction,
      inputType: inputType ?? this.inputType,
      isPassword: isPassword ?? this.isPassword,
      key: key ?? this.key,
      label: label ?? this.label,
      margin: margin ?? this.margin,
      maxLength: maxLength ?? this.maxLength,
      nextNode: nextNode ?? this.nextNode,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      onSubmit: onSubmit ?? this.onSubmit,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      validator: validator ?? this.validator,
    );
  }

  static String? emptyValidator(String? value) {
    return value?.isEmpty ?? true ? emptyValidationMessage : null;
  }

  static String? nullValidator(Object? value) {
    return value == null ? emptyValidationMessage : null;
  }

  static String? emailValidator(String? value) {
    return value != null && !RegExp(emailRegex).hasMatch(value)
        ? emailValidationMessage
        : null;
  }
}

class _EnigmaTextFieldState extends State<EnigmaTextField> {
  bool _obscuredState = true;

  @override
  void initState() {
    super.initState();

    final _onFocusChange = widget.onFocusChange;
    final _focusNode = widget.focusNode;
    if (_onFocusChange != null && _focusNode != null) {
      _focusNode.addListener(() => _onFocusChange(_focusNode.hasFocus));
    }

    final _controller = widget.controller;
    final _initialValue = widget.initialValue;
    if (_controller != null && _initialValue != null) {
      _controller.text = _initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextFormField textField;

    final _onSubmit = widget.onSubmit;
    final _focusNode = widget.focusNode;
    final _nextNode = widget.nextNode;

    if (widget.isPassword) {
      textField = TextFormField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLength: widget.maxLength,
        inputFormatters: widget.formatters,
        validator: widget.validator ?? EnigmaTextField.emptyValidator,
        textInputAction: widget.inputAction != null
            ? widget.inputAction
            : widget.onSubmit != null
                ? TextInputAction.done
                : TextInputAction.next,
        obscureText: _obscuredState,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
          hintText: widget.hint,
          suffixIcon: IconButton(
            icon: Icon(
              _obscuredState ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() {
              _obscuredState = !_obscuredState;
            }),
          ),
        ),
        textCapitalization: widget.textCapitalization,
        onFieldSubmitted: _onSubmit != null && _focusNode != null
            ? (String v) => _onSubmit(v, _focusNode)
            : (_) => _nextNode != null
                ? _nextNode.requestFocus()
                : FocusScope.of(context).nextFocus(),
      );
    } else {
      textField = TextFormField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLength: widget.maxLength,
        inputFormatters: widget.formatters,
        validator: widget.validator ?? EnigmaTextField.emptyValidator,
        textInputAction: widget.inputAction != null
            ? widget.inputAction
            : widget.onSubmit != null
                ? TextInputAction.done
                : TextInputAction.next,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.label,
          hintText: widget.hint,
        ),
        textCapitalization: widget.textCapitalization,
        onFieldSubmitted: _onSubmit != null && _focusNode != null
            ? (String v) => _onSubmit(v, _focusNode)
            : (_) => _nextNode != null
                ? _nextNode.requestFocus()
                : FocusScope.of(context).nextFocus(),
      );
    }

    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(vertical: 8.0),
      child: textField,
    );
  }
}
