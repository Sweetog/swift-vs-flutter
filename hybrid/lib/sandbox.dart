import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/services/user_service.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/extensions/exception.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/courses/shared/state_util.dart';
import 'package:hybrid/screens/signup/create-account-steps/create_account.dart';
import 'package:hybrid/screens/signup/create-account-steps/verify.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';
import 'package:hybrid/screens/signup/sign-in-steps/signin.dart';


final _entryBtnStyle = UIUtil.createTxtStyle(
  UIUtil.txtSizeCaption1,
  color: BmsColors.verdantGoldBlack,
);

class Sandbox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return CreateAccountVerfiyStep();
  }

  Widget _signInTest() {
    var model = AccountModel();
    model.email = 'test@test.com';
    model.password = 'Harry123';

    return SignIn(
      model: model,
    );
  }

  Widget _createAccountTest() {
    var model = AccountModel();
    model.ageVerified = true;
    model.amateurVerified = true;
    model.email = 'hybrid8@test.com';
    model.password = 'asdasd233';
    model.profileName = 'asdasd';

    return CreateAccountCreateStep(
      model: model,
    );
  }
}
