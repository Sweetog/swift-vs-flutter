import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/@core/ui-components/logo_container.dart';
import 'package:hybrid/@core/util/validator_util.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 40.0, left: 35.0, right: 35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, //probably not needed
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildMemberNumForm(context),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonPrimary(
                    text: 'Reset Password',
                    onPressed: () {
                      _validateForm();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget foo(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: BmsColors.primaryForeground,
        ),
        backgroundColor: BmsColors.primaryBackground,
      ),
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
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildMemberNumForm(context),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonPrimary(
                    text: 'Forgot Password',
                    onPressed: () {
                      _validateForm();
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

  Widget _buildMemberNumForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: _buildTxField(context),
    );
  }

  Widget _buildTxField(context) {
    return BmsTextFormField(
      hintText: 'Enter Email Address',
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidEmail(val)) {
          return;
        }
        _sendForgotPasswordEmail(val);
      },
      onSaved: (String val) {
        _sendForgotPasswordEmail(val);
      },
    );
  }

  String _validateEmail(String value) {
    if (!ValidatorUtil.isValidEmail(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _sendForgotPasswordEmail(String email) async {
    FocusScope.of(context).unfocus();
    _showInSnackBar('Sending Password Reset Email', Duration(seconds: 10));
    await AuthUtil.sendPasswordResetEmail(email);
    _hideSnackBar();
    _showInSnackBar('Email Sent', Duration(seconds: 5));
  }

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      //    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showInSnackBar(String value, Duration duration) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: Text(value), duration: duration));
  }

  void _hideSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }
}
