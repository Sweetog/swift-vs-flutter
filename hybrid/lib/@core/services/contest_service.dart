import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hybrid/@core/models/contest_model.dart';

class ContestService {
  static final url = env.baseUrl;

  static Future<List<ContestModel>> getContests(String courseId) async {
    var functionName = 'contests';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response = await client.get(url + '/$functionName?courseId=$courseId',
          headers: headers);

      List<dynamic> j = json.decode(response.body);

      var ret = List<ContestModel>();

      for (var i = 0; i < j.length; i++) {
        ret.add(ContestModel.fromJson(j[i]));
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
}
