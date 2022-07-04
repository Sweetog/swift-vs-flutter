import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/formatters/currency__input_formatter.dart';
import 'package:hybrid/@core/models/payment_method_model.dart';
import 'package:hybrid/@core/models/user_stripe_model.dart';
import 'package:hybrid/@core/services/payment_service.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/ui-components/button_secondary.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/ui-components/text_form_field.dart';
import 'package:hybrid/@core/ui-components/text_title.dart';
import 'package:hybrid/@core/util/format_util.dart';
import 'package:hybrid/@core/util/string_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/payment/shared/add_payment.dart';
import 'package:hybrid/screens/payment/shared/payment_method.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

const _fundAmount1 = 2500.0;
const _fundAmount2 = 5000.0;
const _fundAmount3 = 7500.0;
const _fundAmount4 = 10000.0;
const _fundsBoxSize = 160.0;
const _otherAmountMin = 5;
final _selectedCurrencyTxtStyle = UIUtil.createTxtStyle(UIUtil.txtSizeTitle1,
    color: BmsColors.primaryBackground);
final _currencyTxtStyle = UIUtil.getTxtStyleTitle1();
final TextStyle _subTitleErrorStyle =
    UIUtil.createTxtStyle(UIUtil.txtSizeCaption2, color: Colors.red);

class AddFunds extends StatefulWidget {
  final UserStripeModel model;

  AddFunds({@required this.model});

  @override
  State<StatefulWidget> createState() => _AddFundsState(model: model);
}

class _AddFundsState extends State<AddFunds> {
  final UserStripeModel model;

  _AddFundsState({@required this.model});

  final _scrollController = new ScrollController();
  var _isDataRequestComplete = false;
  PaymentMethodModel _defaultPaymentMethod;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _otherAmountController = TextEditingController();
  final _otherAmountFocus = FocusNode();
  var _isFundAmt1Selected = false;
  var _isFundAmt2Selected = false;
  var _isFundAmt3Selected = false;
  var _isFundAmt4Selected = false;
  var _fundAmount = 0.0;
  var _addPaymentTapped = false;

  @override
  void initState() {
    super.initState();
    _otherAmountFocus.addListener(_onOtherAmountFocus);

    PaymentService.getDefaultPayment().then((paymentMethod) {
      setState(() {
        _defaultPaymentMethod = paymentMethod;
        _isDataRequestComplete = true;
      });
    });
  }

  @override
  void dispose() {
    //_otherAmountController.removeListener(_getCardTypeFrmNumber);
    _otherAmountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: _buildBody(),
      ),
      bottomNavigationBar: NavBar(index: NavBarIndex.Home),
    );
  }

  Widget _buildBody() {
    if (!_isDataRequestComplete) {
      return Stack(children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Center(
          child: BmsProgressIndicator(),
        ),
      ]);
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: BmsColors.primaryBackground,
                  child: ListTile(
                    title: Text(
                      'Current Funds',
                      style: UIUtil.getTxtStyleTitle3(),
                    ),
                    subtitle: Text(
                      'The current amount in your account.',
                      style: UIUtil.getListTileSubtitileStyle(),
                    ),
                    leading: Icon(
                      Icons.monetization_on,
                      color: BmsColors.primaryForeground,
                    ),
                    trailing: Text(FormatUtil.formatCurrency(model.accountBalance),
                        style: UIUtil.getContestPrizeStyle()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextTitle('Add Funds to Your Account'),
                SizedBox(
                  height: 15,
                ),
                _buildCreditBoxContainer(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: _buildOtherAmountForm(),
                ),
                SizedBox(
                  height: 15,
                ),
                _managePayment(),
                _buildAddPayment(),
                SizedBox(
                  height: 10,
                ),
                _buildConfirmFunds(_fundAmount),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmFunds(double fundAmount) {
    if (_addPaymentTapped) {
      return Container();
    }
    return Column(
      children: <Widget>[
        TextTitle(
          'Confirm Add Funds',
        ),
        Card(
          color: BmsColors.primaryBackground,
          elevation: 2.0,
          child: ListTile(
            title: Text(
              (fundAmount > 0) ? 'Funds Amount' : 'No Funds Entered',
              style: UIUtil.getTxtStyleCaption1(),
            ),
            subtitle: Text(
              (fundAmount > 0)
                  ? 'Amount that will be charged to your Payment Method'
                  : 'Select an Amount Above',
              style: (fundAmount > 0)
                  ? UIUtil.getListTileSubtitileStyle()
                  : _subTitleErrorStyle,
            ),
            leading: Icon(
              Icons.monetization_on,
              size: 32,
              color: BmsColors.primaryForeground,
            ),
            trailing: Text(FormatUtil.formatCurrency(fundAmount),
                style: UIUtil.getContestPrizeStyle()),
            onTap: () {
              if (fundAmount > 0) {
                return;
              }
              _scrollToTop();
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ButtonPrimary(
          text: 'Add Funds',
          onPressed: () {
            if (fundAmount > 0 && _defaultPaymentMethod != null) {
              _showInSnackBar('Adding Funds', Duration(seconds: 10));
              PaymentService.charge(fundAmount, _defaultPaymentMethod.id)
                  .then((_) {
                _hideSnackBar();
                Navigator.of(context).pop();
              });
              return;
            }

            if (_defaultPaymentMethod == null) {
              _showInSnackBar(
                  'Please Add a Payment Method', Duration(seconds: 3));
              _scrollToPayment();
              return;
            }

            _scrollToTop();
            _showInSnackBar(
                'Please Select Funds Amount Above', Duration(seconds: 3));
          },
        ),
      ],
    );
  }

  Widget _managePayment() {
    if (_defaultPaymentMethod == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        TextTitle(
          'Payment Method',
        ),
        PaymentMethod(
          last4: _defaultPaymentMethod.last4,
          brandDisplay: _defaultPaymentMethod.brandDisplay,
          cardType: _defaultPaymentMethod.brand,
          isDefault: true,
          subTitle: 'This is the payment method that will be used.',
        ),
      ],
    );
  }

  Widget _buildAddPayment() {
    if (!_isDataRequestComplete) {
      return Container();
    }

    if (_defaultPaymentMethod == null || _addPaymentTapped) {
      return Column(
        children: <Widget>[
          AddPayment(
            scaffoldKey: _scaffoldKey,
            onCardSaved: (paymentMethodModel) {
              setState(() {
                print('=== payment added: $paymentMethodModel ====');
                _defaultPaymentMethod = paymentMethodModel;
                _addPaymentTapped = false;
              });
            },
          ),
          (_defaultPaymentMethod !=
                  null) //show cancel option if there is a default payment
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    ButtonSecondary(
                      text: 'Cancel Add Payment',
                      onPressed: () {
                        setState(() {
                          _addPaymentTapped = false;
                        });
                      },
                    )
                  ],
                )
              : Container(),
        ],
      );
    }

    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Change Payment Method',
          style: UIUtil.getTxtStyleCaption1(),
        ),
        subtitle: Text(
          'Add a New Payment Method',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        trailing: Icon(
          Icons.add_circle,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
        leading: Icon(
          Icons.credit_card,
          size: 32,
          color: BmsColors.primaryForeground,
        ),
        onTap: () {
          setState(() {
            _addPaymentTapped = true;
          });
          _scrollToPayment();
        },
      ),
    );
  }

  Widget _buildOtherAmountForm() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: BmsTextFormField(
        hintText: 'Other Amount',
        controller: _otherAmountController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        focusNode: _otherAmountFocus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(5),
          WhitelistingTextInputFormatter.digitsOnly,
          CurrencyInputFormatter(),
        ],
        onSaved: (String value) {
          print('onSaved = $value');
        },
        validator: _validateOtherAmount,
      ),
    );
  }

  Widget _buildCreditBoxContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildCreditBox(_fundAmount1, _isFundAmt1Selected, () {
                setState(() {
                  _resetSelectedFundBox();
                  _isFundAmt1Selected = !_isFundAmt1Selected;
                  _otherAmountController.text = '';
                  _fundAmount = _fundAmount1;
                });
              }),
              SizedBox(
                width: 10,
              ),
              _buildCreditBox(_fundAmount2, _isFundAmt2Selected, () {
                setState(() {
                  _resetSelectedFundBox();
                  _isFundAmt2Selected = !_isFundAmt2Selected;
                  _otherAmountController.text = '';
                  _fundAmount = _fundAmount2;
                });
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildCreditBox(_fundAmount3, _isFundAmt3Selected, () {
                setState(() {
                  _resetSelectedFundBox();
                  _isFundAmt3Selected = !_isFundAmt3Selected;
                  _otherAmountController.text = '';
                  _fundAmount = _fundAmount3;
                });
              }),
              SizedBox(
                width: 10,
              ),
              _buildCreditBox(_fundAmount4, _isFundAmt4Selected, () {
                setState(() {
                  _resetSelectedFundBox();
                  _isFundAmt4Selected = !_isFundAmt4Selected;
                  _otherAmountController.text = '';
                  _fundAmount = _fundAmount4;
                });
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCreditBox(
      double amount, bool isSelected, Function onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        width: _fundsBoxSize,
        height: _fundsBoxSize,
        child: Center(
          child: Text(
            FormatUtil.formatCurrency(amount),
            style: (isSelected) ? _selectedCurrencyTxtStyle : _currencyTxtStyle,
          ),
        ),
        decoration: BoxDecoration(
          color: (isSelected)
              ? BmsColors.primaryForeground
              : BmsColors.primaryBackground,
          border: Border.all(
            width: 2.0,
            color: BmsColors.primaryForeground,
          ),
          borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
        ),
      ),
    );
  }

  void _resetSelectedFundBox() {
    _isFundAmt1Selected = false;
    _isFundAmt2Selected = false;
    _isFundAmt3Selected = false;
    _isFundAmt4Selected = false;
  }

  void _onOtherAmountFocus() {
    _resetSelectedFundBox();
    if (!_otherAmountFocus.hasFocus) {
      var val = _otherAmountController.text;
      val = StringUtil.onlyNumbers(val);
      double d = double.tryParse(val);
      if (d == null || d < _otherAmountMin) {
        return;
      }
      setState(() {
        print('==== _onOtherAmountFocus setState $d ====');
        _fundAmount = d * 100;
      });
    }
  }

  String _validateOtherAmount(String value) {
    value = StringUtil.onlyNumbers(value);
    if (value == null || value.isEmpty) {
      return null;
    }

    double d = double.parse(value);

    if (d < _otherAmountMin)
      return 'Minium Entry \$$_otherAmountMin';
    else
      return null;
  }

  void _showInSnackBar(String value, Duration duration) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: Text(value), duration: duration));
  }

  void _hideSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0, //_scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 750),
    );
  }

  void _scrollToPayment() {
    _scrollController.animateTo(
      900, //_scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 750),
    );
  }
}
