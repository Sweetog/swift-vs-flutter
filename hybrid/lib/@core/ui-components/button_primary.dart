import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/ui-components/button_base.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonPrimary({Key key, @required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: BmsColors.primaryBackground,
      borderColor: BmsColors.primaryForeground,
      highlightColor: BmsColors.primaryForeground,
      textColor: BmsColors.primaryForeground,
    );
  }
}
