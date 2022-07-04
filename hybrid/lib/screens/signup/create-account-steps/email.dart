import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/@core/util/validator_util.dart';
import 'package:hybrid/screens/signup/create-account-steps/profile_name.dart';
import 'package:hybrid/screens/signup/shared/account_form.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';

class CreateAccountEmailStep extends StatelessWidget {
      final AccountModel model;
  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  CreateAccountEmailStep({@required this.model});

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 2),
      icon: Icons.email,
      titleText: 'What is your email address?',
      instructionText:
          'You will login with this email address, which also allows us to keep in touch with you.',
      textFormField: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidEmail(val)) {
          return;
        }
        _navigateProfileName(context, val);
      },
      onSaved: (String val) {
        _navigateProfileName(context, val);
      },
    );
  }

  String _validateEmail(String value) {
    if (!ValidatorUtil.isValidEmail(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _navigateProfileName(BuildContext context, String value) async {
    model.email = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountProfileNameStep(
              model: model,
            ),
      ),
    );
  }
}
