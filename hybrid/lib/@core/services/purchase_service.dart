import 'package:flutter/material.dart';
import 'package:hybrid/@core/models/purchase_model.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum PurchaseResult { Success, NotEnoughFunds, InvalidRequest, UnknownError }

class PurchaseService {
  static final url = env.baseUrl;

  static Future<List<PurchaseModel>> getPurchases() async {
    var functionName = 'purchases';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.get(url + '/v2/$functionName', headers: headers);

      List<dynamic> j = json.decode(response.body);

      var ret = List<PurchaseModel>();

      for (var i = 0; i < j.length; i++) {
        ret.add(PurchaseModel.fromJson(j[i]));
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

  static Future<PurchaseResult> purchase(
      {@required String contestId,
      @required String courseId,
      @required memberNumber}) async {
    var functionName = 'purchase';
    var body = {
      'contestId': contestId,
      'courseId': courseId,
      'memberNumber': memberNumber
    };
    var client = http.Client();

    try {
      print('purchase post request body: $body');
      var headers = await HttpUtil.getHeaders();
      var response = await client.post(url + '/v2/$functionName',
          headers: headers, body: json.encode(body));

      print('purchase post response statusCode: ${response.statusCode}');

      if (response.statusCode == 204 || response.statusCode == 200) {
        return PurchaseResult.Success;
      }

      if (response.statusCode == 422) {
        return PurchaseResult.NotEnoughFunds;
      }

      if (response.statusCode == 400) {
        return PurchaseResult.InvalidRequest;
      }

      throw Exception('Failed to purchase');
    } catch (e) {
      print('caught http exception');
      print(e);
      return PurchaseResult.UnknownError;
    } finally {
      client.close();
    }
  }
}
