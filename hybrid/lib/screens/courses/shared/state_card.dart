import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/courses/shared/state_model.dart';
import 'package:hybrid/screens/courses/shared/state_util.dart';

class StateCard extends StatelessWidget {
  final StateModel state;

  StateCard({@required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 120,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: FractionalOffset.center,
              image: StateUtil.buildImg(state.imgName),
            )),
          ),
          Container(
            height: 120.0,
            decoration: BoxDecoration(
              border:
                  Border.all(color: BmsColors.primaryForeground, width: 2.0),
              borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
              color: Colors.black.withOpacity(.5),
            ),
          ),
          Center(
            child: Text(state.name, style: UIUtil.getTxtStyleTitle1()),
          ),
        ],
      ),
    );
  }
}
