

import 'package:flutter/material.dart';

class UserStripeModel {
  final String stripeCustomerId;
  final double accountBalance;

    UserStripeModel(
      {@required this.stripeCustomerId,
      @required this.accountBalance});

  UserStripeModel.fromJson(Map<String, dynamic> json)
      : stripeCustomerId = json['stripeCustomerId'],
        accountBalance = -1.0*json['accountBalance'];
}