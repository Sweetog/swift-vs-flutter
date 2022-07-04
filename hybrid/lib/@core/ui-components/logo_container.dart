import 'package:flutter/material.dart';
import 'package:hybrid/@core/util/ui_util.dart';

class LogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
          ),
          child: Container(
            height: 120.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage('assets/logo-gold-member.png'),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'PLAY BIG',
              style: UIUtil.getTxtStyleTitle2(),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'WIN BIGGER',
              style: UIUtil.getTxtStyleTitle1(),
            ),
          ],
        ),
      ],
    );
  }
}
