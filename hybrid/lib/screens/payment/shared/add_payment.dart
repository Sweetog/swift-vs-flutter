import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/models/payment_method_model.dart';
import 'package:hybrid/@core/ui-components/button_primary.dart';
import 'package:hybrid/@core/util/stripe_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/payment/shared/card_animator.dart';
import 'package:hybrid/screens/payment/shared/card_utils.dart';
import 'package:hybrid/screens/payment/shared/input_formatters.dart';

final _txtFieldStyle = UIUtil.getTxtStyleCaption1();

class AddPayment extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(PaymentMethodModel paymentMethodModel) onCardSaved;
  final String btnText;

  AddPayment(
      {@required this.scaffoldKey,
      @required this.onCardSaved,
      this.btnText = 'Add Payment'});

  @override
  State<StatefulWidget> createState() => _AddPaymentState(
      scaffoldKey: scaffoldKey, onCardSaved: onCardSaved, btnText: btnText);
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(PaymentMethodModel paymentMethodModel) onCardSaved;
  final String btnText;

  _AddPaymentState(
      {@required this.scaffoldKey, @required this.onCardSaved, this.btnText});

  final GlobalKey<CardAnimatorState> _animatedStateKey =
      GlobalKey<CardAnimatorState>();
  final _creditCardController = TextEditingController();
  final _expDateController = TextEditingController();
  final _ccvController = TextEditingController();
  final _ccFocus = FocusNode();
  final _expDateFocus = FocusNode();
  final _ccvFocus = FocusNode();
  var _paymentCard = PaymentCard();

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    StripeUtil.ensureFreshSession();

    _paymentCard.type = CardType.Others;
    //_creditCardController.addListener(_onCcChange);
    _creditCardController.addListener(_getCardTypeFrmNumber);
    _expDateController.addListener(_onExpDateChange);

    _ccvFocus.addListener(_onCcvFocusChange);
  }

  @override
  void dispose() {
    _creditCardController.removeListener(_getCardTypeFrmNumber);
    _creditCardController.dispose();
    _expDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text('Add Payment', style: UIUtil.getTxtStyleTitle1()),
          SizedBox(
            height: 8,
          ),
          CardAnimator(_animatedStateKey),
          SizedBox(
            height: 20,
          ),
          _buildCreditCardInput(),
          SizedBox(
            height: 20,
          ),
          ButtonPrimary(
            text: btnText,
            onPressed: () {
              _validateInputs();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardInput() {
    double width = MediaQuery.of(context).size.width;
    TextStyle hintStyle = UIUtil.createTxtStyle(
      UIUtil.txtSizeCaption1,
      color: BmsColors.primaryForeground.withOpacity(0.5),
    );
    return Container(
      height: 45.0,
      width: width,
      decoration: BoxDecoration(color: BmsColors.blackGrey),
      child: Row(
        children: <Widget>[
          CardUtils.getCardIcon(_paymentCard.type),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        controller: _creditCardController,
                        style: _txtFieldStyle,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _ccFocus,
                        onFieldSubmitted: (String val) {
                          FocusScope.of(context).requestFocus(_expDateFocus);
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: '4242 4242 4242 4242',
                          hintStyle: hintStyle,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          CardNumberInputFormatter(),
                        ],
                        onSaved: (String value) {
                          print('onSaved = $value');
                          print(
                              'Num controller has = ${_creditCardController.text}');
                          _paymentCard.number =
                              CardUtils.getCleanedNumber(value);
                        },
                        validator: CardUtils.validateCardNum,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: _expDateController,
                          style: _txtFieldStyle,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: _expDateFocus,
                          decoration: InputDecoration.collapsed(
                            hintText: 'MM/YY',
                            hintStyle: hintStyle,
                          ),
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter()
                          ],
                          validator: CardUtils.validateDate,
                          onSaved: (value) {
                            List<int> expiryDate =
                                CardUtils.getExpiryDate(value);
                            _paymentCard.month = expiryDate[0];
                            _paymentCard.year = expiryDate[1];
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _ccvController,
                        style: _txtFieldStyle,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: _ccvFocus,
                        onFieldSubmitted: (String val) {
                          _validateInputs();
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'CVC',
                          hintStyle: hintStyle,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: CardUtils.validateCVV,
                        onSaved: (value) {
                          _paymentCard.cvv = int.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onExpDateChange() {
    if (_expDateController.text != null &&
        _expDateController.text.length == 5) {
      FocusScope.of(context).requestFocus(_ccvFocus);
    }
  }

  void _onCcvFocusChange() {
    _animatedStateKey.currentState.animate();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(_creditCardController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _showInSnackBar(String value, Duration duration) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: UIUtil.getTxtStyleSnackBar(),
      ),
      duration: duration,
    ));
  }

  void _hideSnackBar() {
    scaffoldKey.currentState.hideCurrentSnackBar();
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.',
          Duration(seconds: 3));
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      _showInSnackBar('Saving...', Duration(seconds: 10));
      StripeUtil.saveCardAndSetDefault(_paymentCard.number, _paymentCard.cvv,
              _paymentCard.month, _paymentCard.year)
          .then((paymentMethodModel) {
        _hideSnackBar();
        onCardSaved(paymentMethodModel);
      });
    }
  }
}
