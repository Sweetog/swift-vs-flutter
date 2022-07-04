import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/home/home.dart';
import 'package:hybrid/screens/signup/shared/account_model.dart';
import 'package:hybrid/screens/signup/shared/account_scaffold.dart';
import 'package:hybrid/screens/signup/start.dart';

class CreateAccountCreateStep extends StatefulWidget {
  final AccountModel model;

  CreateAccountCreateStep({@required this.model});

  @override
  State<StatefulWidget> createState() =>
      _CreateAccountCreateStepState(model: model);
}

class _CreateAccountCreateStepState extends State<CreateAccountCreateStep> {
  final AccountModel model;

  _CreateAccountCreateStepState({@required this.model});

  AuthResult _authResult;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _createAccount(model),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildBody();
          }

          _authResult = snapshot.data;
          return _buildBody();
        });
  }

  Widget _buildBody() {
    return Container(
      decoration: UIUtil.getDecorationBg(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: _buildAccountScaffold(),
      ),
    );
  }

  Widget _buildAccountScaffold() {
    double width = MediaQuery.of(context).size.width;

    return AccountScaffold(
      progressBarWidth: width,
      automaticallyImplyLeading: true,
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 38.0,
              color: BmsColors.primaryForeground,
            ),
            Text('Creating Account...', style: UIUtil.getTxtStyleTitle1()),
            Center(
              child: _buildProgressIndicator(_authResult),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: _buildStatusTxt(_authResult),
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

  Widget _buildStatusTxt(AuthResult result) {
    if (result == null) {
      return Container();
    }

    var txt;

    switch (result) {
      case AuthResult.CreationError:
      case AuthResult.Unknown:
      case AuthResult.UserDbRecordCreationError:
        txt = 'Account Creation Failed, Please Try Again';
        break;
      case AuthResult.Exists:
        txt = 'Your Account Already Exists';
        break;
      case AuthResult.Created:
        txt = 'Account Created!';
        break;
      case AuthResult.TooManyAttempts:
      case AuthResult.InvalidUsernameOrPassword:
      case AuthResult.SignInSuccess:
      case AuthResult.NoProviderPassword:
      case AuthResult.DoesNotExist:
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
      case AuthResult.CreationError:
      case AuthResult.Unknown:
      case AuthResult.UserDbRecordCreationError:
        btnText = 'Try Again';
        onPressed = () {
          _redraw();
        };
        break;
      case AuthResult.Exists:
        btnText = 'Login To Your Account';
        onPressed = () {
          _navigateStart(context);
        };
        break;
      case AuthResult.Created:
        btnText = 'Continue';
        onPressed = () {
          _navigateHome(context);
        };
        break;
      case AuthResult.TooManyAttempts:
      case AuthResult.InvalidUsernameOrPassword:
      case AuthResult.SignInSuccess:
      case AuthResult.NoProviderPassword:
      case AuthResult.DoesNotExist:
        // Nothing to do
        return Container();
        break;
    }

    return ButtonPrimary(
      text: btnText,
      onPressed: onPressed,
    );
  }

  Future<AuthResult> _createAccount(AccountModel model) async {
    return await AuthUtil.createAccount(model.profileName, model.email,
        model.password, model.courseId, model.memberNumber, 'player');
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
}
