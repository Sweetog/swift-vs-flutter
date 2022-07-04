import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';

class BmsProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   width: 32.0,
    //   height: 32.0,
    //   child: CircularProgressIndicator(
    //     backgroundColor: BmsColors.primaryForegroundColor,
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
    //   ),
    // );
    return CircularProgressIndicator(
      backgroundColor: BmsColors.verdantGoldBlack,
      valueColor: AlwaysStoppedAnimation<Color>(BmsColors.primaryForeground),
    );
  }
}

Widget _getProgressIndicator(BuildContext context) {
  bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
  if (isIos) {
    return Center(
      child: CupertinoActivityIndicator(
        animating: true,
      ),
    );
  } else {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: BmsColors.primaryForeground,
      ),
    );
  }
}
