import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class AccountScaffold extends StatelessWidget {
  final double progressBarWidth;
  final Widget child;
  final bool automaticallyImplyLeading;
  GlobalKey<ScaffoldState> scaffoldKey;

  AccountScaffold(
      {@required this.child,
      @required this.progressBarWidth,
      this.automaticallyImplyLeading = true,
      this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UIUtil.getDecorationBg(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: BmsColors.primaryForeground,
          ),
          backgroundColor: BmsColors.primaryBackground,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 10.0,
                  width: progressBarWidth,
                  decoration: BoxDecoration(
                    color: BmsColors.primaryForeground,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      child,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
