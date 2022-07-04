import 'dart:async';

import 'package:hybrid/@core/models/payment_method_model.dart';
import 'package:hybrid/@core/services/payment_service.dart';
import 'package:stripe_api/stripe_api.dart';

class StripeUtil {
  static Future<void> ensureFreshSession() async {
    endSession();
    initCustomerSession();
    getCustomer();
  }

  static Future<void> getCustomer() async {
    try {
      final customer = await CustomerSession.instance.retrieveCurrentCustomer();
      print(customer);
    } catch (error) {
      print(error);
    }
  }

  static void initCustomerSession() {
    CustomerSession.initCustomerSession(PaymentService.createEphemeralKey);
  }

  static void endSession() {
    CustomerSession.endCustomerSession();
  }

  static Future<void> saveCard(
      String number, int cvc, int expMonth, int expYear) async {
    StripeCard card = StripeCard(
        number: number,
        cvc: cvc.toString(),
        expMonth: expMonth,
        expYear: expYear);

    try {
      var cardToken = await Stripe.instance.createCardToken(card);
      var _ =
          await CustomerSession.instance.addCustomerSource(cardToken.id);
    } catch (e) {
      print(e);
    }
  }

  static Future<PaymentMethodModel> saveCardAndSetDefault(
      String number, int cvc, int expMonth, int expYear) async {
    try {
      await saveCard(number, cvc, expMonth, expYear);
      return await _changeDefaultCard();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PaymentMethodModel> _changeDefaultCard() async {
    try {
      final customer = await CustomerSession.instance.retrieveCurrentCustomer();
      if(customer.sources == null || customer.sources.length <= 0){
        throw Exception('Default Card Change Attempt, No Sources');
      }
      if(customer.sources.length == 1) {
        final firstCardInAccount =customer.sources[0].asCard(); //When there is Zero souces Stripe automatically sets card added as default
        return PaymentMethodModel(id: firstCardInAccount.id, brand: PaymentMethodModel.getBrand(firstCardInAccount.brand), brandDisplay: firstCardInAccount.brand, last4: firstCardInAccount.last4, isDefault: true);
      }
      final card = customer.sources[1].asCard();
      final _ =
          await CustomerSession.instance.updateCustomerDefaultSource(card.id);
     return PaymentMethodModel(id: card.id, brand: PaymentMethodModel.getBrand(card.brand), brandDisplay: card.brand, last4: card.last4, isDefault: true);
    } catch (error) {
      print(error);
      return null;
    }
  }

  static void deleteCard(String sourceId) async {
    try {
      final _ = await CustomerSession.instance.deleteCustomerSource(sourceId);
    } catch (error) {
      print(error);
    }
  }
}
