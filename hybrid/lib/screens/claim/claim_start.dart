import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/purchase_model.dart';
import 'package:hybrid/@core/services/claim_service.dart';
import 'package:hybrid/@core/services/user_service.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/text_title.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/contests/shared/contest_card.dart';
import 'package:hybrid/screens/courses/shared/course_header_small.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';

class TeeboxConstants {
  static const String Blue = 'Blue';
  static const String White = 'White';
  static const String Black = 'Black';
  static const String Red = 'Red';
  static const String Gold = 'Gold';

  static const List<String> choices = <String>[Gold, Black, Blue, White, Red];
}

class ClaimStart extends StatefulWidget {
  final PurchaseModel purchaseModel;
  final ContestModel comboContestModel;

  ClaimStart({@required this.purchaseModel, this.comboContestModel});

  @override
  State<StatefulWidget> createState() => _ClaimStartState(
      purchaseModel: purchaseModel, comboContestModel: comboContestModel);
}

class _ClaimStartState extends State<ClaimStart> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _teeBoxMenuKey = GlobalKey();
  final PurchaseModel purchaseModel;
  final ContestModel comboContestModel;
  TimeOfDay _selectedTime;
  String _selectedTeeBox;
  var _claimCreated = false;
  _ClaimStartState({@required this.purchaseModel, this.comboContestModel});

  @override
  Widget build(BuildContext context) {
    print('purchaseId: ${purchaseModel.id}');
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
              courseModel: purchaseModel.course,
            ),
            ContestCard(
                contestModel: (comboContestModel != null)
                    ? comboContestModel
                    : purchaseModel.contest),
            SizedBox(
              height: 10,
            ),
            TextTitle('Claim Form'),
            _buildTimeCard(),
            _buildTeeBoxCard(),
            SizedBox(
              height: 10,
            ),
            (_claimCreated)
                ? Container()
                : ButtonPrimary(
                    text: 'Send Claim',
                    onPressed: () {
                      if (!_isFormValid()) {
                        _showInSnackBar(
                          'Please Enter the Time of Day and the Tee Box Above.',
                          Duration(seconds: 5),
                        );
                        return;
                      }
                      _showConfirmClaimDialog();
                    },
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeCard() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: (_selectedTime != null)
            ? Text(
                'Time of day: ${_selectedTime.format(context)}',
                style: UIUtil.getTxtStyleTitle3(),
              )
            : Text(
                'Enter Time of Day',
                style: UIUtil.getTxtStyleTitle3(),
              ),
        subtitle: (_selectedTime != null)
            ? Text('Time of Day Provided',
                style: UIUtil.getListTileSubtitileStyle())
            : Text(
                'Please Estimate the time of day that you started hole ${purchaseModel.course.hole}.',
                style: UIUtil.getListTileSubtitileStyle(),
              ),
        leading: Icon(
          Icons.timer,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon((_selectedTime != null) ? Icons.check : Icons.add,
              size: 32, color: BmsColors.primaryForeground),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildTeeBoxCard() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: (_selectedTeeBox != null)
            ? Text(
                'Teebox: $_selectedTeeBox',
                style: UIUtil.getTxtStyleTitle3(),
              )
            : Text(
                'Enter Tee Box',
                style: UIUtil.getTxtStyleTitle3(),
              ),
        subtitle: (_selectedTeeBox != null)
            ? Text(
                'Tee Box Selected',
                style: UIUtil.getListTileSubtitileStyle(),
              )
            : Text(
                'Please enter the tee box you started from on hole ${purchaseModel.course.hole}.',
                style: UIUtil.getListTileSubtitileStyle(),
              ),
        leading: Icon(
          Icons.explore,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
        trailing: Theme(
          data: Theme.of(context).copyWith(
            cardColor: BmsColors.primaryBackground,
          ),
          child: PopupMenuButton<String>(
            icon: Icon(
              (_selectedTeeBox != null) ? Icons.check : Icons.add,
              size: 32,
              color: BmsColors.primaryForeground,
            ),
            key: _teeBoxMenuKey,
            onSelected: onTeeBoxSelected,
            itemBuilder: (BuildContext context) {
              return TeeboxConstants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: UIUtil.getTxtStyleCaption2(),
                  ),
                );
              }).toList();
            },
          ),
        ),
        onTap: () {
          dynamic state = _teeBoxMenuKey.currentState;
          state.showButtonMenu();
        },
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showTimePicker(
      initialTime: TimeOfDay(hour: 0, minute: 0),
      context: context,
    );

    if (picked != null) {
      print('time picked: $picked');
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void onTeeBoxSelected(String teeBox) {
    if (teeBox != null) {
      setState(() {
        _selectedTeeBox = teeBox;
      });
    }
  }

  bool _isFormValid() {
    if (_selectedTime == null || _selectedTeeBox == null) {
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

  void _showConfirmClaimDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              cardColor: BmsColors.primaryBackground,
            ),
            child: AlertDialog(
              title: Text(
                'Are you sure?',
                style: UIUtil.getTxtStyleCaption1(),
              ),
              content: Text(
                'Is all data correct and you are ready to start the claim process?',
                style: UIUtil.getTxtStyleCaption2(),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes, Start Claim'),
                  onPressed: () {
                    Navigator.pop(context); //pop confirm dialog
                    submitClaim();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void submitClaim() {
    ClaimService.createClaim(
      model: purchaseModel,
      teeBox: _selectedTeeBox,
      time: _selectedTime.format(context),
      comboContestName:
          (comboContestModel != null) ? comboContestModel.name : null,
      comboContestPayout:
          (comboContestModel != null) ? comboContestModel.payout : null,
    ).then((result) {
      if (result == ClaimStatus.ClaimCreated) {
        _showInSnackBar(
          'Claim Successfully Created.',
          Duration(seconds: 10),
        );
        setState(() {
          _claimCreated = true;
        });
        return;
      }

      if (result == ClaimStatus.ClaimAlreadyStarted) {
        _showInSnackBar(
          'You have already started your claim for this contest.',
          Duration(seconds: 10),
        );
        setState(() {
          _claimCreated = true;
        });
        return;
      }

      _showInSnackBar(
        'There was an error. Please try again in 15 seconds.',
        Duration(seconds: 10),
      );
    });
  }
}
