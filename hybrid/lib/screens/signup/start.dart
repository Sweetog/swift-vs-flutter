import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/button_secondary.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/@core/ui-components/logo_container.dart';
import 'package:hybrid/screens/signup/create-account-steps/start.dart';
import 'package:hybrid/screens/signup/forgot_password.dart';
import 'package:hybrid/screens/signup/sign-in-steps/email.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: UIUtil.getDecorationBg(),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LogoContainer(),
                  Container(
                    height: 20.0,
                  ),
                  ButtonPrimary(
                    text: 'Create Account',
                    onPressed: () {
                      _navigateCreateAccount(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: ButtonSecondary(
                      text: 'Sign In',
                      onPressed: () {
                        _navigateSignInEmail(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    child: Text(
                      'Forgot Password',
                      style: UIUtil.getTxtStyleCaption2Underline(),
                    ),
                    onTap: () {
                      _navigateForgotPassword(context);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateForgotPassword(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => CreateAccountEmailStep()),
      MaterialPageRoute(builder: (context) => ForgotPassword()),
    );
  }

  void _navigateCreateAccount(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => CreateAccountEmailStep()),
      MaterialPageRoute(builder: (context) => CreateAccountStartStep()),
    );
  }

  void _navigateSignInEmail(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInStepEmailStep()),
    );
  }
}
