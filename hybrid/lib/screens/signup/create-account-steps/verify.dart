import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/signup/create-account-steps/create_account.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';
import 'package:hybrid/screens/signup/shared/account_scaffold.dart';

//CreateAccountProfileNameStep
class CreateAccountVerfiyStep extends StatefulWidget {
  final AccountModel model;

  CreateAccountVerfiyStep({@required this.model});

  @override
  State<StatefulWidget> createState() =>
      _CreateAccountVerfiyStepState(model: model);
}

class _CreateAccountVerfiyStepState extends State<CreateAccountVerfiyStep> {
  final AccountModel model;

  _CreateAccountVerfiyStepState({@required this.model});

  @override
  Widget build(BuildContext context) {
    return AccountScaffold(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 5),
      child: Column(
        children: <Widget>[
          Text('By Creating your Account, you Agree to:',
              style: UIUtil.getTxtStyleTitle3()),
          SizedBox(
            height: 10,
          ),
          _buildVerifyAge(),
          _buildVerifyAmateur(),
          _buildVerifyTerms(),
          _buildVerifyMembership(),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Text(
                    'Terms & Conditions',
                    style: UIUtil.getTxtStyleCaption1Underline(),
                  ),
                  onTap: () => HttpUtil.launchTerms(),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Text(
                    'Privacy Policy',
                    style: UIUtil.getTxtStyleCaption1Underline(),
                  ),
                  onTap: () => HttpUtil.launchContestRules(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ButtonPrimary(
            text: 'Create Account',
            onPressed: () {
              _navigateCreateAccount();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyAge() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Being At Least 18',
          style: UIUtil.getTxtStyleCaption1(),
        ),
        subtitle: Text(
          'You Agree to being at Least 18 years of Age',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.assignment_ind,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
      ),
    );
  }

  Widget _buildVerifyAmateur() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Being an Amateur',
          style: UIUtil.getTxtStyleCaption1(),
        ),
        subtitle: Text(
          'You must be an amateur player as defined by United States Golf Association (“USGA”) under the “Rules of Amateur Status”.',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.brightness_auto,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
      ),
    );
  }

  Widget _buildVerifyTerms() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Our Terms & Privacy Policy',
          style: UIUtil.getTxtStyleCaption1(),
        ),
        subtitle: Text(
          'By creating your account you are indicating that you have read and agree to the Big Money Shot Privacy Policy and Terms of Use.',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.event_note,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
      ),
    );
  }

  Widget _buildVerifyMembership() {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Being a Member at a Private Golf Course',
          style: UIUtil.getTxtStyleCaption1(),
        ),
        subtitle: Text(
          'By creating your account, you are indicating that you have an active membership at a participating golf course.',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.account_circle,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
      ),
    );
  }

  void _navigateCreateAccount() async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountCreateStep(
          model: model,
        ),
      ),
    );
  }
}
