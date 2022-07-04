import 'package:flutter/material.dart';
import 'package:hybrid/env.dart';
import 'package:hybrid/sandbox.dart';
import 'package:stripe_api/stripe_api.dart';
import 'app.dart';
import 'dart:io' show Platform;

void main() {
  var baseUrl =
      'http://10.0.2.2:5000/bigmoneyshot-f4694/us-central1/apptest'; //android simualtor

  if (Platform.isIOS) {
    baseUrl =
        'http://localhost:5000/bigmoneyshot-f4694/us-central1/apptest'; //ios simulator
  }

  Stripe.init('pk_test_LE1UOoCjd2gdJxssw9XyGlJx');

  BuildEnvironment.init(flavor: BuildFlavor.test, baseUrl: baseUrl);
  assert(env != null);
  runApp(App());
}
