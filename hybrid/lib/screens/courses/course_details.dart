import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/course_detail_model.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/services/contest_service.dart';
import 'package:hybrid/@core/services/course_service.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/format_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/contests/contest_details.dart';
import 'package:hybrid/screens/courses/shared/course_header_full.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

final _contestNameStyle = UIUtil.createTxtStyle(
  UIUtil.txtSizeTitle2,
  color: BmsColors.funZoneGreen,
);
final _entryBtnStyle = UIUtil.createTxtStyle(
  UIUtil.txtSizeCaption1,
  color: BmsColors.verdantGoldBlack,
);
final _contestDetailsStyle = UIUtil.createTxtStyle(
  14,
  color: BmsColors.primaryForeground,
);

class CourseDetails extends StatefulWidget {
  final String id;

  CourseDetails({@required this.id});

  @override
  State<StatefulWidget> createState() => _CourseDetailsState(id: id);
}

class _CourseDetailsState extends State<CourseDetails> {
  final String id;
  _CourseDetailsState({@required this.id});
  CourseDetailModel _courseDetailModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCourseAndContests(id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          _courseDetailModel = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Courses),
    );
  }

  Widget _buildBody() {
    if (_courseDetailModel == null) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: UIUtil.getDecorationBg(),
          ),
          Center(
            child: BmsProgressIndicator(),
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CourseHeaderFull(
              courseModel: _courseDetailModel.course,
            ),
            _buildContestListView(),
          ],
        ),
      ],
    );
  }

  Widget _buildContestListView() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: (_courseDetailModel.contests != null)
              ? _courseDetailModel.contests.length
              : 0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print('=== onTap ===');
              },
              child: Card(
                color: BmsColors.primaryBackground,
                elevation: 2.0,
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: BmsColors.primaryForeground,
                    ),
                    borderRadius:
                        BorderRadius.circular(UIUtil.defaultBorderRadius),
                  ),
                  height: 140,
                  child: Column(
                    children: <Widget>[
                      Text(
                        _courseDetailModel.contests[index].name,
                        style: _contestNameStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image(
                              width: 50,
                              image: AssetImage('assets/icon-app.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: FlatButton(
                                color: BmsColors.primaryForeground,
                                child: Text(
                                  'Entry ${FormatUtil.formatCurrencyInt(_courseDetailModel.contests[index].amount)}',
                                  style: _entryBtnStyle,
                                ),
                                onPressed: () {
                                  _navigateContestDetails(
                                      context,
                                      _courseDetailModel.contests[index],
                                      _courseDetailModel.course);
                                },
                              ),
                            ),
                            Text(
                              FormatUtil.formatCurrencyInt(
                                  _courseDetailModel.contests[index].payout),
                              style: _contestNameStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Contest Date - ${FormatUtil.formatDateDefault(DateTime.now())}',
                              style: _contestDetailsStyle,
                            ),
                            Text(
                              _courseDetailModel.contests[index].payoutLabel,
                              style: _contestDetailsStyle,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<CourseDetailModel> _getCourseAndContests(courseId) async {
    var course = await CourseService.getCourse(courseId);
    var contests = await ContestService.getContests(courseId);

    return CourseDetailModel(course: course, contests: contests);
  }

  void _navigateContestDetails(BuildContext context, ContestModel contestModel,
      CourseModel courseModel) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContestDetails(
          contestModel: contestModel,
          courseModel: courseModel,
        ),
      ),
    );
  }
}
