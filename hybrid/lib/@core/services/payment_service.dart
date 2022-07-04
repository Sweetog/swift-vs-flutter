import 'dart:async';
import 'package:hybrid/@core/models/payment_method_model.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static final url = env.baseUrl;

  static Future<PaymentMethodModel> getDefaultPayment() async {
    var completer = Completer<PaymentMethodModel>();

    try {
      getPaymentMethods().then((payments) {
        if (payments == null || payments.length <= 0) {
          completer.complete(null);
          return;
        }
        for (var i = 0; i < payments.length; i++) {
          if (payments[i].isDefault) {
            completer.complete(payments[i]);
            return;
          }
        }

        completer.complete(null);
      });
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  static Future<List<PaymentMethodModel>> getPaymentMethods() async {
    var functionName = 'paymentMethods';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.get(url + '/$functionName/', headers: headers);

      if (response.body == null || response.body.isEmpty) {
        return null;
      }

      List<dynamic> jsonRes = json.decode(response.body);

      var ret = List<PaymentMethodModel>();
      for (var i = 0; i < jsonRes.length; i++) {
        ret.add(PaymentMethodModel.fromJson(jsonRes[i]));
      }

      return ret;
    } catch (e) {
      print('caught http exception');
      print(e);
      return null;
    } finally {
      client.close();
    }
  }

  static Future<String> createEphemeralKey(String apiVersion) async {
    var functionName = 'ephemeralKey';
    var body = {'api_version': apiVersion};
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response = await client.post(url + '/$functionName',
          headers: headers, body: json.encode(body));
      final d = json.decode(response.body);
      if (response.statusCode == 200) {
        final key = json.encode(d);
        return key;
      } else {
        throw Exception('Failed to get ephemeralKey');
      }
    } catch (e) {
      print('caught http exception');
      print(e);
      return null;
    } finally {
      client.close();
    }
  }

  static Future<void> charge(double amount, String source,
      {String currency = 'usd'}) async {
    var functionName = 'charge';
    var body = {'amount': amount, 'source': source, 'currency': currency};
    print('=== body $body ====');
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response = await client.post(url + '/$functionName',
          headers: headers, body: json.encode(body));

      print('====== response.statusCode ${response.statusCode} =====');
      if (response.statusCode != 204 || response.statusCode != 200) {
        throw Exception('Failed to charge');
      }
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }
}
