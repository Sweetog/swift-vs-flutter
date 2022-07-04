import 'package:flutter/material.dart';

class BmsColors {
  //dart singleton pattern
  static final BmsColors _bmsColors = BmsColors._internal();
  BmsColors._internal();
  factory BmsColors() => _bmsColors;

  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static Color get funZoneGold => Color(0xFFfdd87f);
  static Color get funZoneRed => Color(0xFFb44647);
  static Color get funZoneGreen => Color(0xFF589e86);
  static Color get funZoneOrange => Color(0xFFf47e31);
  static Color get white70 => Colors.white70;
  static Color get verdantGoldBlack => Color(0xFF040706);
  static Color get oldLogoGold => Color(0xFFe3be5d);
  static Color get lightFunZoneGold => Color(0xFFfef1d3);
  static Color get darkFunZoneGold => Color(0xFFfbb91b);
  static Color get blackGrey => Color(0xFF1f2124);

  static Color get primaryForeground => funZoneGold;
  static Color get accent => funZoneGreen;
  static Color get primaryBackground => verdantGoldBlack;

  MaterialColor getPrimaryBackgroundColorMaterial() {
    return MaterialColor(0xFF040706, color); //verdantGoldBlack
  }

  //static Color get
}
