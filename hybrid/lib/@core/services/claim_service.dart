import 'package:flutter/material.dart';
import 'package:hybrid/@core/models/purchase_model.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ClaimStatus { ClaimCreated, ClaimCreationError, ClaimAlreadyStarted }

class ClaimService {
  static final url = env.baseUrl;

  static Future<ClaimStatus> createClaim(
      {@required PurchaseModel model,
      @required String time,
      @required String teeBox,
      String comboContestName,
      int comboContestPayout}) async {
    var functionName = 'claim';
    var client = http.Client();

    var body = {
      'purchaseId': model.id,
      'time': time,
      'teeBox': teeBox,
      'comboContestName': comboContestName,
      'comboContestPayout': comboContestPayout
    };

    try {
      var headers = await HttpUtil.getHeaders();
      var response = await client.post(url + '/$functionName',
          headers: headers, body: json.encode(body));

      if (response.statusCode == 204 || response.statusCode == 200) {
        return ClaimStatus.ClaimCreated;
      }

      if (response.statusCode == 429) {
        return ClaimStatus.ClaimAlreadyStarted;
      }

      throw Exception('http error');
    } catch (e) {
      print('caught http exception');
      print(e);
      return ClaimStatus.ClaimCreationError;
    } finally {
      client.close();
    }
  }
}
