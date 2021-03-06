import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/stripe_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/home/home.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';
import 'package:hybrid/screens/signup/shared/account_scaffold.dart';

import '../start.dart';

class SignIn extends StatefulWidget {
  final AccountModel model;

  SignIn({@required this.model});

  @override
  State<StatefulWidget> createState() => _SignInState(model: model);
}

class _SignInState extends State<SignIn> {
  final AccountModel model;
  var _authResult;

  _SignInState({@required this.model});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _handleSignIn(model.email, model.password),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return _buildBody();
        }

        _authResult = snapshot.data;
        return _buildBody();
      },
    );
    ;
  }

  Widget _buildBody() {
    return Container(
      decoration: UIUtil.getDecorationBg(),
      child: WillPopScope(
        onWillPop: () async => _authResult != AuthResult.SignInSuccess,
        child: _buildAccountScaffold(),
      ),
    );
  }

  Widget _buildAccountScaffold() {
    double width = MediaQuery.of(context).size.width;

    return AccountScaffold(
      progressBarWidth: width,
      automaticallyImplyLeading: _authResult != AuthResult.SignInSuccess,
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.security,
              size: 38.0,
              color: BmsColors.primaryForeground,
            ),
            _buildTitleTxt(_authResult),
            Center(
              child: _buildProgressIndicator(_authResult),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: _buildStatusTxt(_authResult, model.email),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: _buildBtn(_authResult),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTxt(AuthResult result) {
    var txt = 'Signing in...';

    if (result == AuthResult.SignInSuccess) {
      txt = 'Welcome Back!';
    }

    return Text(txt, style: UIUtil.getTxtStyleTitle1());
  }

  Widget _buildStatusTxt(AuthResult result, String email) {
    if (result == null) {
      return Container();
    }

    var txt;

    switch (result) {
      case AuthResult.InvalidUsernameOrPassword:
        txt = 'Invalid Username or Password';
        break;
      case AuthResult.Unknown:
        txt = 'Sign In Failed - Unknown Reason';
        break;
      case AuthResult.SignInSuccess:
        txt = 'Signin Success';
        break;
      case AuthResult.NoProviderPassword:
        txt = 'You created your account with Facebook or Google';
        break;
      case AuthResult.DoesNotExist:
        txt = 'An account for ${email} does not exist';
        break;
      case AuthResult.TooManyAttempts:
        txt = 'Account Temporaily Locked, Too Many Incorrect Attempts';
        break;
      case AuthResult.CreationError:
      case AuthResult.UserDbRecordCreationError:
      case AuthResult.Created:
      case AuthResult.Exists:
        // Nothing to do
        return Container();
        break;
    }

    return Text(
      txt,
      style: UIUtil.getTxtStyleCaption1(),
    );
  }

  Widget _buildBtn(AuthResult result) {
    if (result == null) {
      return Container();
    }

    var btnText;
    var onPressed;

    switch (result) {
      case AuthResult.InvalidUsernameOrPassword:
        btnText = 'Go Back';
        onPressed = () {
          Navigator.of(context).pop();
        };
        break;
      case AuthResult.Unknown:
        btnText = 'Try Again';
        onPressed = () {
          _redraw();
        };
        break;
      case AuthResult.SignInSuccess:
        btnText = 'Home';
        onPressed = () {
          _navigateHome(context);
        };
        break;
      case AuthResult.NoProviderPassword:
        btnText = 'Start Over';
        onPressed = () {
          _navigateStart(context);
        };
        break;
      case AuthResult.DoesNotExist:
        btnText = 'Start Over';
        onPressed = () {
          _navigateStart(context);
        };
        break;
      case AuthResult.TooManyAttempts:
        btnText = 'Go Back';
        onPressed = () {
          Navigator.of(context).pop();
        };
        break;
      case AuthResult.CreationError:
      case AuthResult.UserDbRecordCreationError:
      case AuthResult.Created:
      case AuthResult.Exists:
        // Nothing to do
        return Container();
        break;
    }

    return ButtonPrimary(
      text: btnText,
      onPressed: onPressed,
    );
  }

  Widget _buildProgressIndicator(AuthResult result) {
    if (result == null) {
      return BmsProgressIndicator();
    }

    return Container();
  }

  void _redraw() {
    setState(() {
      _authResult = null;
    });
  }

  void _navigateHome(BuildContext context) async {
    UIUtil.navigateAsRoot(Home(), context);
  }

  void _navigateStart(BuildContext context) async {
    UIUtil.navigateAsRoot(Start(), context);
  }

  Future<AuthResult> _handleSignIn(String email, String password) async {
    var result = await AuthUtil.signIn(email, password);
    //start Stripe Session
    // StripeUtil.initCustomerSession();
    // await StripeUtil.getCustomer();
    return result;
  }
}
