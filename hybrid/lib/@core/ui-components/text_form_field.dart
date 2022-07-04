import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/util/ui_util.dart';

final TextStyle _textFieldStyle = UIUtil.getDefaultTxtFieldStyle();
final TextStyle _errorStyle = UIUtil.createTxtStyle(18, color: Colors.red);
final TextStyle _hintTextStyle = UIUtil.getTxtStyleTitle3();

class BmsTextFormField extends TextFormField {
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String hintText;
  final TextStyle styleOverride;
  final int maxLines;
  final bool obscureText;

  BmsTextFormField(
      {Key key,
      this.onSaved,
      this.onFieldSubmitted,
      this.keyboardType,
      this.validator,
      this.textInputAction,
      this.inputFormatters,
      this.focusNode,
      this.controller,
      this.hintText,
      this.styleOverride,
      this.maxLines = 1,
      this.obscureText = false})
      : super(
            key: key,
            maxLines: maxLines,
            style: (styleOverride != null) ? styleOverride : _textFieldStyle,
            decoration: InputDecoration(
              hintStyle: _hintTextStyle,
              hintText: hintText,
              errorStyle: _errorStyle,
              fillColor: Colors.red,
            ),
            onSaved: onSaved,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: keyboardType,
            validator: validator,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            controller: controller,
            textAlign: TextAlign.center,
            obscureText: obscureText);
}
