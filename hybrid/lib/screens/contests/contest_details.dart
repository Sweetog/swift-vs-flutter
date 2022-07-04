import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/models/user_model.dart';
import 'package:hybrid/@core/services/purchase_service.dart';
import 'package:hybrid/@core/services/user_service.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/account/confirm_contest.dart';
import 'package:hybrid/screens/contests/shared/contest_card.dart';
import 'package:hybrid/screens/contests/shared/contest_fee.dart';
import 'package:hybrid/screens/contests/shared/contest_rules.dart';
import 'package:hybrid/screens/courses/shared/course_header_small.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class ContestDetails extends StatefulWidget {
  final CourseModel courseModel;
  final ContestModel contestModel;

  ContestDetails({@required this.contestModel, @required this.courseModel});

  @override
  State<StatefulWidget> createState() => _ContestDetailsState(
      contestModel: contestModel, courseModel: courseModel);
}

class _ContestDetailsState extends State<ContestDetails> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CourseModel courseModel;
  final ContestModel contestModel;
  var _isBusy = false;
  final _scrollController = new ScrollController();
  final _memberNumberFocusNode = FocusNode();
  UserModel _userModel;

  _ContestDetailsState(
      {@required this.contestModel, @required this.courseModel});

  @override
  void initState() {
    super.initState();
    _memberNumberFocusNode.addListener(_onMemberNumberFocus);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          _userModel = snapshot.data;
          return _buildScaffold();
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Home),
    );
  }

  Widget _buildBody() {
    if (_userModel == null) {
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
        ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CourseHeaderSmall(courseModel: courseModel),
                //ContestCard(contestModel: contestModel),
                ContestFee(
                  contestModel: contestModel,
                ),
                _buildContestList(contestModel),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: _buildMemberNumForm(),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ButtonPrimary(
                    text: 'Confirm Entry',
                    onPressed: () {
                      _validateForm();
                      // _navigateContestMember(
                      //     context, contestModel, courseModel);
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContestList(ContestModel contest) {
    if (contest.contests == null || contest.contests.length == 0) {
      return Container();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: contestModel.contests.length,
      itemBuilder: (BuildContext context, int index) {
        return ContestCard(contestModel: contestModel.contests[index]);
      },
    );
  }

  Widget _buildMemberNumForm() {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: BmsTextFormField(
        hintText: 'Enter Member Number',
        focusNode: _memberNumberFocusNode,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: validateMemberNum,
        inputFormatters: [
          LengthLimitingTextInputFormatter(25),
          //WhitelistingTextInputFormatter.digitsOnly,
        ],
        onFieldSubmitted: (String val) {
          if (val == null || val.isEmpty) {
            return;
          }
          _showConfirmEntryDialog(val);
        },
        onSaved: (String value) {
          print('onSaved = $value');
          _showConfirmEntryDialog(value);
        },
        //validator: _validateOtherAmount,
      ),
    );
  }

  String validateMemberNum(String value) {
    if (value == null || value.isEmpty)
      return 'Please Provide Your Member Number';
    else
      return null;
  }

  _getUser() async {
    var result = await AuthUtil.getCurrentUser();
    return UserService.getUser(result.uid);
  }

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      //    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _purchaseContest(String memberNumber) {
    if (_isBusy) {
      return;
    }

    if (memberNumber == null || memberNumber.isEmpty) {
      _showInBar(
          'Please Enter Your Golf Course Member Number', Duration(seconds: 3));
      return;
    }

    _isBusy = true;
    _showInBar('Entering Contest', Duration(seconds: 10));

    PurchaseService.purchase(
            contestId: contestModel.id,
            courseId: courseModel.id,
            memberNumber: memberNumber)
        .then((result) {
      _isBusy = false;
      _hideBar();
      if (result == PurchaseResult.Success) {
        _navigateConfirmContest(context, contestModel, courseModel);
      }
      // if (result == PurchaseResult.NotEnoughFunds) {
      //   _showInBar(
      //       'You Do Not Have Enough Funds, Please Add Funds on Account Tab.',
      //       Duration(seconds: 10));
      // }
    });
  }

  void _navigateConfirmContest(BuildContext context, ContestModel contestModel,
      CourseModel courseModel) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmContest(
            contestModel: contestModel, courseModel: courseModel),
      ),
    );
  }

  void _showInBar(String value, Duration duration) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: UIUtil.getTxtStyleSnackBar(),
      ),
      duration: duration,
    ));
  }

  void _hideBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  void _onMemberNumberFocus() {
    _scrollToBottom();
  }

  void _scrollToBottom() {
    print('scrollToBottom');
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 750),
    );
  }

  void _showConfirmEntryDialog(String memberNumber) {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              cardColor: BmsColors.primaryBackground,
            ),
            child: AlertDialog(
              title: Text(
                'Confirm Entry Into Contest',
                style: UIUtil.getTxtStyleCaption1(),
              ),
              content: Text(
                (_userModel.accountBalance >= contestModel.amount)
                    ? 'Your credit will be used for this contest'
                    : 'Your member account will be billed for this contest.',
                style: UIUtil.getTxtStyleCaption2(),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes, Enter Contest'),
                  onPressed: () {
                    Navigator.pop(context); //pop confirm dialog
                    _purchaseContest(memberNumber);
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
}
