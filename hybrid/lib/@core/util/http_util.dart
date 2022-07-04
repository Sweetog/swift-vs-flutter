import 'dart:io';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpUtil {
  static Future<Map<String, String>> getHeaders() async {
    var token = await AuthUtil.getBearerToken();
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
  }

  static void launchTerms() async {
    const url = 'https://www.bigmoneyshot.com/terms';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchContestRules() async {
    const url = 'https://www.bigmoneyshot.com/contest-rules';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
