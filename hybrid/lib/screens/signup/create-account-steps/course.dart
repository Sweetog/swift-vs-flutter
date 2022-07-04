import 'package:flutter/material.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/services/course_service.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/courses/shared/course_header_full.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';
import 'package:hybrid/screens/signup/create-account-steps/member_number.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';

class CreateAccountCourseStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateAccountCourseStepState();
}

class _CreateAccountCourseStepState extends State<CreateAccountCourseStep> {
  List<CourseModel> _courses;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CourseService.getCourses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          _courses = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: BmsAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_courses == null) {
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
            Text('Choose Your Course', style: UIUtil.getTxtStyleTitle1()),
            Padding(
              padding: EdgeInsets.only(
                  top: 8.0, left: 35.0, right: 35.0, bottom: 15.0),
              child: Text('Touch your course below:',
                  style: UIUtil.getListTileSubtitileStyle()),
            ),
            _buildCourseListView(),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseListView() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: (_courses != null) ? _courses.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                var courseId = _courses[index].id;
                _navigateMemberNumber(context, courseId);
              },
              child: CourseHeaderFull(
                courseModel: _courses[index],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateMemberNumber(BuildContext context, String value) async {
    var model = AccountModel();
    model.courseId = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateAccountMemberNumberStep(model: model)),
    );
  }
}
