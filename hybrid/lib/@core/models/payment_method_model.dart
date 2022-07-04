import 'package:flutter/material.dart';
import 'package:hybrid/screens/payment/shared/card_utils.dart';

class PaymentMethodModel {
  final String id;
  final CardType brand;
  final String brandDisplay;
  final String last4;
  final String tokenizationMethod;
  final bool isDefault;

  PaymentMethodModel(
      {@required this.id,
      @required this.brand,
      @required this.brandDisplay,
      @required this.last4,
      @required this.isDefault,
      this.tokenizationMethod});

  PaymentMethodModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        brand = getBrand(json['brand']),
        brandDisplay = json['brand'],
        tokenizationMethod = json['tokenizationMethod'],
        last4 = json['last4'],
        isDefault = json['isDefault'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brandDisplay,
        'last4': last4,
        'tokenizationMethod': tokenizationMethod,
        'isDefault': isDefault
      };

  static CardType getBrand(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return CardType.Visa;
        break;
      case 'mastercard':
        return CardType.Master;
        break;
      case 'american express':
        return CardType.AmericanExpress;
        break;
      case 'diners club':
        return CardType.DinersClub;
        break;
      case 'jcb':
        return CardType.Jcb;
        break;
      case 'discover':
        return CardType.Discover;
        break;
    }
    return CardType.Others;
  }
}
