import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/@core/util/validator_util.dart';
import 'package:hybrid/screens/signup/shared/account_form.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';
import 'package:hybrid/screens/signup/sign-in-steps/password.dart';

class SignInStepEmailStep extends StatelessWidget {
  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 1,
          totalSteps: 2),
      icon: Icons.email,
      titleText: 'Sign In',
      instructionText:
          'Use the Email Address you provided when you created your account.',
      textFormField: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidEmail(val)) {
          return;
        }
        _navigatePassword(context, val);
      },
      onSaved: (String val) {
        _navigatePassword(context, val);
      },
    );
  }

  String _validateEmail(String value) {
    if (!ValidatorUtil.isValidEmail(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _navigatePassword(BuildContext context, String value) async {
    var model = AccountModel();
    model.email = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPasswordStep(
              model: model,
            ),
      ),
    );
  }
}
