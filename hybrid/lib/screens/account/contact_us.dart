import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/services/admin_service.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/account/confirm_contest.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  FirebaseUser _currentUser;
  bool _autoValidate = false;
  var _messageSent = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthUtil.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          _currentUser = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Home),
    );
  }

  Widget _buildBody() {
    if (_currentUser == null) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: UIUtil.getDecorationBg(),
          ),
          Center(
            child: BmsProgressIndicator(),
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildMemberNumCard(_currentUser.email),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: _buildContactForm(),
                ),
                SizedBox(
                  height: 15,
                ),
                (_messageSent)
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: ButtonPrimary(
                            text: 'Send Message',
                            onPressed: () => _validateForm()),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberNumCard(String email) {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Contact Us',
          style: UIUtil.getTxtStyleTitle3(),
        ),
        subtitle: Text(
          'We will respond via your email address: $email',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.contact_mail,
          color: BmsColors.primaryForeground,
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: BmsTextFormField(
        hintText: 'Enter Message',
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        validator: validateMessage,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        onFieldSubmitted: (String val) {
          if (val == null || val.isEmpty) {
            return;
          }
          sendMessage(_currentUser.email, val);
        },
        onSaved: (String val) {
          print('onSaved = $val');
          sendMessage(_currentUser.email, val);
        },
        //validator: _validateOtherAmount,
      ),
    );
  }

  void _showInSnackBar(String value, int seconds) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: UIUtil.getTxtStyleSnackBar(),
      ),
      duration: Duration(seconds: seconds),
    ));
  }

  void _hideSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  String validateMessage(String value) {
    if (value == null || value.isEmpty)
      return 'Please Enter Your Message';
    else
      return null;
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

  void sendMessage(email, message) async {
    var result = await AdminService.contactUs(email: email, message: message);

    if (result == ContactUsStatus.Error) {
      _showInSnackBar(
          'There was an error, please wait 30 seconds and try again', 10);
      return;
    }

    _showInSnackBar('Message Sent, We will contact you shortly', 10);
    setState(() {
      _messageSent = true;
    });
  }
}
