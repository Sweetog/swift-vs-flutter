import 'package:flutter/material.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/courses/shared/state_card.dart';
import 'package:hybrid/screens/courses/shared/state_model.dart';
import 'package:hybrid/screens/courses/shared/state_util.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';
import 'package:hybrid/screens/signup/create-account-steps/course.dart';

class CreateAccountStartStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateAccountStartStepState();
}

class _CreateAccountStartStepState extends State<CreateAccountStartStep> {
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
                Text('Choose Your Course', style: UIUtil.getTxtStyleTitle1()),
                Padding(
                  padding: EdgeInsets.only(
                      top: 8.0, left: 35.0, right: 35.0, bottom: 15.0),
                  child: Text(
                      'Note, you must be a member at a partipating course, if you are a guest today, go to the club house or find an attendant to enter a contest available.',
                      style: UIUtil.getListTileSubtitileStyle()),
                ),
                _buildStatesListView(),
              ],
            ),
          ],
        ),
      ),
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
                  _navigateCreateAccountStart(context);
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

  void _navigateCreateAccountStart(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountCourseStep()),
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
