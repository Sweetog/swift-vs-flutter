import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/signup/create-account-steps/password.dart';
import 'package:hybrid/screens/signup/shared/account_form.dart';
import 'package:hybrid/screens/signup/shared/account_helper.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';

const profileNameMinLength = 5;
const profileNameMaxLength = 25;

class CreateAccountProfileNameStep extends StatelessWidget {
  CreateAccountProfileNameStep({@required this.model});

  final AccountModel model;

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      progressBarWidth: AccountHelper.getCreateAccountProgressWidth(context, 3),
      icon: Icons.person,
      titleText: 'Choose Your Profile Name',
      instructionText:
          'This will be your display name, order players will be avle to find you and connect using your profile name.',
      textFormField: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      keyboardType: TextInputType.text,
      validator: _validateProfileName,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!_isValidProfileName(val)) {
          return;
        }
        _navigatePassword(context, val);
      },
      onSaved: (String val) {
        _navigatePassword(context, val);
      },
    );
  }

  String _validateProfileName(String value) {
    if (!_isValidProfileName(value))
      return 'Minimum $profileNameMinLength characters and no more than $profileNameMaxLength';
    else
      return null;
  }

  void _navigatePassword(BuildContext context, String value) async {
    model.profileName = value;
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountPasswordStep(
              model: model,
            ),
      ),
    );
  }

  bool _isValidProfileName(String value) {
    return (value.length >= profileNameMinLength &&
        value.length <= profileNameMaxLength);
  }
}
