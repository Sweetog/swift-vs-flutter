import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/payment_method_model.dart';
import 'package:hybrid/@core/services/payment_service.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/stripe_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/payment/add_payment_screen.dart';
import 'package:hybrid/screens/payment/shared/card_front_icon.dart';
import 'package:hybrid/screens/payment/shared/payment_method.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

class ManagePayments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagePaymentsState();
}

class _ManagePaymentsState extends State<ManagePayments> {
  List<PaymentMethodModel> _paymentsMethods;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getPaymentMethods(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              _paymentsMethods = [];
            }
            return _buildScaffold();
          }

          _paymentsMethods = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Account),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BmsColors.primaryForeground,
        onPressed: () {
          _navigateAddPayment(context);
        },
        tooltip: 'Add Payment',
        child: Icon(
          Icons.add,
          size: 32,
          color: BmsColors.primaryBackground,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_paymentsMethods == null) {
      return Stack(children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Center(
          child: BmsProgressIndicator(),
        ),
      ]);
      //return Center(child: BmsProgressIndicator());
    }

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
                height: 10,
              ),
              Text('Payment Methods', style: UIUtil.getTxtStyleTitle1()),
              SizedBox(
                height: 8,
              ),
              CardFrontIcon(),
              SizedBox(
                height: 8,
              ),
              _buildPaymentMethodListItems(_paymentsMethods),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodListItems(List<PaymentMethodModel> list) {
    if (list == null || list.length <= 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            child: Text(
              'No Payment Methods, Press + to Add',
              style: UIUtil.getTxtStyleCaption1(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ObjectKey(list[index]),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  /// edit item
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  /// delete
                  return true;
                }
              },
              onDismissed: (direction) {
                setState(() {
                  var paymentMethod = list[index];
                  list.removeAt(index);
                  _showDeletePaymentDialog(paymentMethod);
                });
              },
              child: PaymentMethod(
                last4: list[index].last4,
                brandDisplay: list[index].brandDisplay,
                cardType: list[index].brand,
                isDefault: list[index].isDefault,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<PaymentMethodModel>> _getPaymentMethods() async {
    return await PaymentService.getPaymentMethods();
  }

  void _navigateAddPayment(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentScreen()),
    );
  }

  void _showDeletePaymentDialog(PaymentMethodModel paymentMethod) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Method?'),
            content: const Text(
                'Are you sure you want to delete this payment method?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  StripeUtil.deleteCard(paymentMethod.id);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
