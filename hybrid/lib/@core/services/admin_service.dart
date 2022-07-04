import 'package:flutter/material.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ContactUsStatus { Ok, Error }

class AdminService {
  static final url = env.baseUrl;

  static Future<ContactUsStatus> contactUs(
      {@required String email, @required String message}) async {
    var functionName = 'contactus';
    var client = http.Client();

    var body = {'email': email, 'message': message};

    try {
      var headers = await HttpUtil.getHeaders();
      await client.post(url + '/$functionName',
          headers: headers, body: json.encode(body));
      return ContactUsStatus.Ok;
    } catch (e) {
      print('caught http exception');
      print(e);
      return ContactUsStatus.Error;
    } finally {
      client.close();
    }
  }
}
