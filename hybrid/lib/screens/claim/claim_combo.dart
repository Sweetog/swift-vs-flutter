import 'package:flutter/material.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/purchase_model.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/claim/claim_start.dart';
import 'package:hybrid/screens/contests/shared/contest_card.dart';
import 'package:hybrid/screens/courses/shared/course_header_small.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class ClaimCombo extends StatefulWidget {
  final PurchaseModel model;

  ClaimCombo({@required this.model});

  @override
  State<StatefulWidget> createState() => _ClaimComboState(model: model);
}

class _ClaimComboState extends State<ClaimCombo> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PurchaseModel model;
  ContestModel _selectedContest;
  _ClaimComboState({@required this.model});

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Home),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CourseHeaderSmall(
              courseModel: model.course,
            ),
            SizedBox(
              height: 10,
            ),
            // _buildTimeCard(),
            // _buildTeeBoxCard(),
            _buildContestList(),
            SizedBox(
              height: 10,
            ),
            ButtonPrimary(
              text: 'Continue',
              onPressed: () {
                if (!_isFormValid()) {
                  _showInSnackBar(
                    'Please select which contest you won above.',
                    Duration(seconds: 5),
                  );
                  return;
                }
                _navigateClaim(context, model, _selectedContest);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContestList() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: model.contest.contests.length,
          itemBuilder: (BuildContext context, int index) {
            return ContestCard(
              contestModel: model.contest.contests[index],
              selected: (_selectedContest != null)
                  ? (model.contest.contests[index].name ==
                      _selectedContest.name)
                  : false,
              onTap: () {
                setState(() {
                  _selectedContest = model.contest.contests[index];
                });
              },
            );
          },
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_selectedContest == null) {
      return false;
    }
    return true;
  }

  void _showInSnackBar(String value, Duration duration) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: UIUtil.getTxtStyleSnackBar(),
      ),
      duration: duration,
    ));
  }

  void _hideSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  void _navigateClaim(BuildContext context, PurchaseModel model,
      ContestModel comboContestModel) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimStart(
              purchaseModel: model,
              comboContestModel: comboContestModel,
            ),
      ),
    );
  }
}
