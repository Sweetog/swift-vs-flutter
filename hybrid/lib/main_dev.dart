import 'package:flutter/material.dart';
import 'package:hybrid/env.dart';
import 'app.dart';

void main() {
  BuildEnvironment.init(
      flavor: BuildFlavor.test, baseUrl: 'https://us-central1-bigmoneyshot-f4694.cloudfunctions.net/apptest');
  assert(env != null);
  runApp(App());
}