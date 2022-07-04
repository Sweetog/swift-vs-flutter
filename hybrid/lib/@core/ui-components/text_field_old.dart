import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';

class BmsTextFieldOld extends StatelessWidget {
  BmsTextFieldOld({
      @required this.controller,
      @required this.hintText,
      @required this.labelText,
      @required this.inputFormatter,
      this.keyboardType = TextInputType.text});

  final double _padding = 5.0;

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputFormatter inputFormatter;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(
        fontFamily: 'Lalezar', color: BmsColors.primaryForeground);
    TextStyle errorStyle = TextStyle(
        fontFamily: 'Lalezar', color: Colors.blue, fontSize: 22,);
    TextStyle textStyle = TextStyle(
        fontFamily: 'Lalezar', color: BmsColors.primaryForeground, fontSize: 18.0);
    return Padding(
      padding: EdgeInsets.only(top: this._padding, bottom: this._padding),
      child: TextField(
        controller: this.controller,
        style: textStyle,
        inputFormatters: [
          this.inputFormatter
        ],
        decoration: InputDecoration(
          errorStyle: errorStyle,
          hintText: this.hintText,
          labelStyle: labelStyle,
          labelText: this.labelText,
          fillColor: BmsColors.primaryBackground,
          filled: true,
          contentPadding: EdgeInsets.all(12.0),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: BmsColors.primaryForeground, width: 2.0),
            borderRadius:
                BorderRadius.circular(UIUtil.defaultBorderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: BmsColors.primaryForeground, width: 2.0),
            borderRadius:
                BorderRadius.circular(UIUtil.defaultBorderRadius),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        keyboardType: this.keyboardType,
      ),
    );
  }
}
