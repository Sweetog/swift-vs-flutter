import 'package:flutter/material.dart';
import '../bms_colors.dart';

class UIUtil {
  //dart singleton pattern
  // static final UIUtil _uiUtil = UIUtil._internal();
  // UIUtil._internal();
  // factory UIUtil() => _uiUtil;

  static const double _defaultFontSize = 22.0;
  static const double _defaultBorderRadius = 8.0;
  static const double _defaultTextFieldFontSize = 24.0;
  static const double _txtSizeTitle1 = 30.0;
  static const double _txtSizeTitle2 = 26.0;
  static const double _txtSizeTitle3 = 20.0;
  static const double _txtSizeCaption1 = 18.0;
  static const double _txtSizeCaption2 = 15.0;
  static const String _font = 'Lalezar';
  static final Color _fontColor = BmsColors.primaryForeground;

  static double get defaultBorderRadius => _defaultBorderRadius;
  static double get txtSizeCaption1 => _txtSizeCaption1;
  static double get txtSizeCaption2 => _txtSizeCaption2;
  static double get txtSizeTitle1 => _txtSizeTitle1;
  static double get txtSizeTitle2 => _txtSizeTitle2;
  static double get txtSizeTitle3 => _txtSizeTitle3;

  static BoxDecoration getDecorationBg() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/bg.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  static TextStyle createTxtStyle(double size, {Color color}) {
    if (color == null) {
      color = _fontColor;
    }
    return TextStyle(
      fontFamily: _font,
      color: color,
      fontSize: size,
    );
  }

  static TextStyle getDefaultTxtStyle() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _defaultFontSize,
    );
  }

  static TextStyle getListTileSubtitileStyle() {
    return TextStyle(
      fontFamily: _font,
      color: BmsColors.accent,
      fontSize: _txtSizeCaption2,
    );
  }

  static TextStyle getContestPrizeStyle() {
    return TextStyle(
      fontFamily: _font,
      color: BmsColors.funZoneGreen,
      fontSize: txtSizeTitle2,
    );
  }

  static TextStyle getContestPrizeStyleSmall() {
    return TextStyle(
      fontFamily: _font,
      color: BmsColors.funZoneGreen,
      fontSize: txtSizeTitle3,
    );
  }

  static TextStyle getDefaultTxtFieldStyle() {
    return TextStyle(
        fontFamily: _font,
        color: _fontColor,
        fontSize: _defaultTextFieldFontSize);
  }

  static TextStyle getTxtStyleTitle1() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeTitle1,
    );
  }

  static TextStyle getTxtStyleTitle2() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeTitle2,
    );
  }

  static TextStyle getTxtStyleTitle3() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeTitle3,
    );
  }

  static TextStyle getTxtStyleCaption1() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeCaption1,
    );
  }

  static TextStyle getTxtStyleCaption1Underline() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeCaption1,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle getTxtStyleCaption2() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeCaption2,
    );
  }

    static TextStyle getTxtStyleSnackBar() {
    return TextStyle(
      fontFamily: _font,
      color: BmsColors.funZoneGreen,
      fontSize: _txtSizeCaption2,
    );
  }

  static TextStyle getTxtStyleCaption2Underline() {
    return TextStyle(
        fontFamily: _font,
        color: _fontColor,
        fontSize: _txtSizeCaption2,
        decoration: TextDecoration.underline);
  }

  static navigateAsRoot(Widget widget, BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }
}
