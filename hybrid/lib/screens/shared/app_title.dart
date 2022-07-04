import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo-gold-member-nav.png',
          fit: BoxFit.contain,
          height: 33,
        )
      ],
    );
  }
}
