import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/ui-components/button_base.dart';

class ButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonSecondary({Key key, @required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: BmsColors.primaryBackground,
      borderColor: Colors.blueGrey,
      highlightColor: BmsColors.primaryBackground,
      textColor: BmsColors.oldLogoGold,
    );
  }
}
