import 'package:flutter/material.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/courses/course_details.dart';
import 'package:hybrid/screens/courses/shared/state_card.dart';
import 'package:hybrid/screens/courses/shared/state_model.dart';
import 'package:hybrid/screens/courses/shared/state_util.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

const _grandCourseId = 'ILXBlsKJW8Cdqk27MTq5';

class Courses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List<StateModel> _states;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _states = StateUtil.buildStatesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            decoration: UIUtil.getDecorationBg(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStatesListView(),
            ],
          ),
        ],
      )),
      bottomNavigationBar: NavBar(index: NavBarIndex.Courses),
    );
  }

  Widget _buildStatesListView() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: _states.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (_states[index].name.toLowerCase() == 'california') {
                  _navigateCourseDetails(context);
                  return;
                }
                _showInSnackBar(
                    'Courses in ${_states[index].name} Coming Soon!');
              },
              child: StateCard(
                state: _states[index],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateCourseDetails(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CourseDetails(id: _grandCourseId)),
    );
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: UIUtil.getTxtStyleSnackBar(),
      ),
      duration: new Duration(seconds: 3),
    ));
  }
}
