import 'dart:async';

import 'package:hybrid/@core/util/shared_preferences_util.dart';

class UserUtil {
  static Future<double> getAccountBalance() async {
    var completer = Completer<double>();
    // SharedPreferencesUtil.getAccountBalance().then((accountBalance) {
    //   if(accountBalance == null || )
    // });

    return completer.future;
  }
}
