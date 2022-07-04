import 'package:flutter/material.dart';

class BmsText extends StatelessWidget {
  BmsText({this.text});

  final String text;
  final TextStyle textStyle =
      TextStyle(fontFamily: 'Lalezar', decoration: TextDecoration.none, color: Colors.white, fontSize: 90.0);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        this.text,
        style: textStyle,
      ),
    );
  }
}
