import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/courses/shared/state_model.dart';
import 'package:hybrid/screens/courses/shared/state_util.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class States extends StatelessWidget {
  final List<StateModel> _states = StateUtil.buildStatesList();
  final void Function(String state) onStateSelected;

  States({@required this.onStateSelected});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: _states.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                onStateSelected(_states[index].name);
              },
              child: Card(
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
                        image: StateUtil.buildImg(_states[index].imgName),
                      )),
                    ),
                    Container(
                      height: 120.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: BmsColors.primaryForeground, width: 2.0),
                        borderRadius:
                            BorderRadius.circular(UIUtil.defaultBorderRadius),
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                    Center(
                      child: Text(_states[index].name,
                          style: UIUtil.getTxtStyleTitle1()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
