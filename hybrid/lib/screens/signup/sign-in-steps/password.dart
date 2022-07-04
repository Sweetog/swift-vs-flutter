import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/@core/util/validator_util.dart';
import 'package:hybrid/screens/signup/shared/account_form.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';
import 'package:hybrid/screens/signup/sign-in-steps/signin.dart';

class SignInPasswordStep extends StatelessWidget {
  SignInPasswordStep({@required this.model});

  final AccountModel model;

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 2,
          totalSteps: 2),
      icon: Icons.lock,
      titleText: 'Enter your password',
      instructionText: '',
      textFormField: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      validator: _validatePassword,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidPassword(val)) {
          return;
        }
        _navigateSignIn(context, val);
      },
      onSaved: (String val) {
        _navigateSignIn(context, val);
      },
    );
  }

  String _validatePassword(String value) {
    if (!ValidatorUtil.isValidPassword(value))
      return 'At least: 6 chars, 1 letter, 1 number';
    else
      return null;
  }

  void _navigateSignIn(BuildContext context, String value) async {
    model.password = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignIn(
              model: model,
            ),
      ),
    );
  }
}
