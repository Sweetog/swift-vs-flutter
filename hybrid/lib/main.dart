import 'package:flutter/material.dart';
import 'package:hybrid/env.dart';
import 'package:stripe_api/stripe_api.dart';
import 'app.dart';

void main() {
  Stripe.init('pk_live_xiD2RhQ9bOVZhvD93ckbl5zK');

  BuildEnvironment.init(
      flavor: BuildFlavor.live,
      baseUrl: 'https://us-central1-bigmoneyshot-f4694.cloudfunctions.net/app');
  assert(env != null);
  runApp(App());
}
