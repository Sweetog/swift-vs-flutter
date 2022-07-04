import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/env.dart';
import 'package:hybrid/sandbox.dart';
import 'package:hybrid/screens/home/home.dart';
import '@core/bms_colors.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //       //systemNavigationBarColor: Colors.blue,
    //       // statusBarColor: Colors.pink,
    //       //statusBarBrightness: Brightness.dark),
    // ); //iOS
    return MaterialApp(
      debugShowCheckedModeBanner: env.flavor == BuildFlavor.test,
      showPerformanceOverlay: false,
      title: 'Big Money Shot',
      theme: ThemeData(
          //primarySwatch: BmsColors().getPrimaryBackgroundColorMaterial(),
          primarySwatch: BmsColors().getPrimaryBackgroundColorMaterial(),
          hintColor: BmsColors.primaryForeground,
          brightness: Brightness.dark, //overrides primarySwatch
          accentColor: BmsColors.accent),
      home: Home(),
    );
  }
}
