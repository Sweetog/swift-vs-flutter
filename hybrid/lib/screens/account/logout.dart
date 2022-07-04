import 'package:flutter/material.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/button_secondary.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/home/home.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildBody(context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm Logout?',
                style: UIUtil.getTxtStyleTitle3(),
              ),
              SizedBox(
                height: 10,
              ),
              ButtonPrimary(
                text: 'Logout',
                onPressed: () {
                  AuthUtil.signOut();
                  UIUtil.navigateAsRoot(Home(), context);
                },
              ),
              SizedBox(
                height: 10,
              ),
              ButtonSecondary(
                text: 'Cancel',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScaffold(context) {
    return Scaffold(
      appBar: BmsAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: NavBar(index: 0),
    );
  }
}
