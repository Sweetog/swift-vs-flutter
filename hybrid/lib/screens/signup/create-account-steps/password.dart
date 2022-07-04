import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/@core/util/validator_util.dart';
import 'package:hybrid/screens/signup/create-account-steps/verify.dart';
import 'package:hybrid/screens/signup/shared/account_form.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';

class CreateAccountPasswordStep extends StatelessWidget {
    final AccountModel model;
  CreateAccountPasswordStep({@required this.model});

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 4),
      icon: Icons.lock,
      titleText: 'Enter your password',
      instructionText: 'You can change this later if you need.',
      textFormField: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      keyboardType: TextInputType.text,
      validator: validatePassword,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidPassword(val)) {
          return;
        }
        navigatePassword(context, val);
      },
      onSaved: (String val) {
        navigatePassword(context, val);
      },
    );
  }

  String validatePassword(String value) {
    if (!ValidatorUtil.isValidPassword(value))
      return 'Minimum 6 chars,1 number';
    else
      return null;
  }

  void navigatePassword(BuildContext context, String value) async {
    model.password = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountVerfiyStep(
              model: model,
            ),
      ),
    );
  }
}
