import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';

class ContestRules extends StatelessWidget {
  var showDownArrow = false;

  ContestRules({this.showDownArrow = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: BmsColors.primaryBackground,
          elevation: 2.0,
          child: ListTile(
            title: Text(
              'Video Verified',
              style: UIUtil.getTxtStyleTitle3(),
            ),
            subtitle: Text(
              'Cameras are live to verify your skill.',
              style: UIUtil.getListTileSubtitileStyle(),
            ),
            leading: Image(
              color: BmsColors.primaryForeground,
              width: 32,
              image: AssetImage('assets/icon-video.png'),
            ),
            trailing: (showDownArrow)
                ? Icon(
                    Icons.arrow_downward,
                    size: 32,
                    color: BmsColors.primaryForeground,
                  )
                : null,
          ),
        ),
        Card(
          color: BmsColors.primaryBackground,
          elevation: 2.0,
          child: ListTile(
            title: Text(
              'Must Play Today',
              style: UIUtil.getTxtStyleTitle3(),
            ),
            subtitle: Text(
              'You must play today to win a prize.',
              style: UIUtil.getListTileSubtitileStyle(),
            ),
            leading: Image(
              color: BmsColors.primaryForeground,
              width: 32,
              image: AssetImage('assets/icon-golf.png'),
            ),
            trailing: (showDownArrow)
                ? Icon(
                    Icons.arrow_downward,
                    size: 32,
                    color: BmsColors.primaryForeground,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
