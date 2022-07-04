import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/signup/create-account-steps/email.dart';
import 'package:hybrid/screens/signup/shared/account_form.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';

class CreateAccountMemberNumberStep extends StatelessWidget {
  final AccountModel model;
  CreateAccountMemberNumberStep({@required this.model});

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 1),
      icon: Icons.golf_course,
      titleText: 'Enter your member number',
      instructionText:
          'This is your golf course member number, this will be used to verify entry to contests and billing your member account.',
      textFormField: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      keyboardType: TextInputType.text,
      validator: validateMemberNum,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onFieldSubmitted: (String val) {
        if (val == null || val.isEmpty) {
          return;
        }
        _navigateCreateAccountStepEmail(context, val);
      },
      onSaved: (String val) {
        _navigateCreateAccountStepEmail(context, val);
      },
    );
  }

  String validateMemberNum(String value) {
    if (value == null || value.isEmpty)
      return 'Please Provide Your Member Number';
    else
      return null;
  }

  void _navigateCreateAccountStepEmail(
      BuildContext context, String value) async {
    model.memberNumber = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateAccountEmailStep(model: model)),
    );
  }
}
