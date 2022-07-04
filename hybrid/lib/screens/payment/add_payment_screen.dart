import 'package:flutter/material.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/payment/shared/add_payment.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';

class AddPaymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      //body: _buildBody(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: 0),
    );
  }

  Widget _buildBody() {
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
              AddPayment(
                  scaffoldKey: _scaffoldKey,
                  onCardSaved: (_) {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
