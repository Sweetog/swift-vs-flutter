import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/contests/shared/contest_rules.dart';
import 'package:hybrid/screens/courses/shared/course_header_small.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

final _successTitleFontStyle = UIUtil.createTxtStyle(UIUtil.txtSizeTitle3,
    color: BmsColors.primaryBackground);

final _successSubtitleFontStyle = UIUtil.createTxtStyle(UIUtil.txtSizeCaption2,
    color: BmsColors.primaryBackground);

class ConfirmContest extends StatefulWidget {
  final CourseModel courseModel;
  final ContestModel contestModel;

  ConfirmContest({@required this.contestModel, @required this.courseModel});

  @override
  State<StatefulWidget> createState() =>
      _ConfirmContest(contestModel: contestModel, courseModel: courseModel);
}

class _ConfirmContest extends State<ConfirmContest> {
  final CourseModel courseModel;
  final ContestModel contestModel;

  _ConfirmContest({@required this.contestModel, @required this.courseModel});

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: BmsAppBar(
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Courses),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CourseHeaderSmall(courseModel: courseModel),
                _buildSuccessSummaryCard(),
                ContestRules(),
                _buildBestOfLuck(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessSummaryCard() {
    return Card(
      color: BmsColors.darkFunZoneGold,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Success! You are Confirmed.',
          style: _successTitleFontStyle,
        ),
        subtitle: Text(
          'You have been successfully entered into today\'s ${contestModel.name} contest.',
          style: _successSubtitleFontStyle,
        ),
        leading: Icon(
          Icons.golf_course,
          color: BmsColors.primaryBackground,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildBestOfLuck() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Play Big!',
          style: UIUtil.getTxtStyleTitle3(),
        ),
        subtitle: Text(
          'Submit your winning claim using the Account tab below.',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.donut_large,
          color: BmsColors.primaryForeground,
          size: 32,
        ),
      ),
    );
  }
}
