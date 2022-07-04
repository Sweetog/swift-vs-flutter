import 'package:flutter/material.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/ui-components/logo_container.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/signup/start.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _isLoggedInResult;

  @override
  void initState() {
    super.initState();
    AuthUtil.isSignedIn().then((result) {
      setState(() {
        _isLoggedInResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedInResult == null) {
      return Container();
    }

    if (!_isLoggedInResult) {
      return Start();
    }

    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Home),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LogoContainer(),
             SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }
}
