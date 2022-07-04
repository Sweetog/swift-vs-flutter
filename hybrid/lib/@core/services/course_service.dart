import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseService {
  static final url = env.baseUrl;

  static Future<List<CourseModel>> getCourses() async {
    var functionName = 'courses';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response = await client.get(url + '/$functionName', headers: headers);

      List<dynamic> j = json.decode(response.body);

      var ret = List<CourseModel>();

      for (var i = 0; i < j.length; i++) {
        ret.add(CourseModel.fromJson(j[i]));
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

  static Future<CourseModel> getCourse(String id) async {
    var functionName = 'course';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.get(url + '/$functionName?id=$id', headers: headers);
      var j = json.decode(response.body);
      return CourseModel.fromJson(j);
    } catch (e) {
      print('caught http exception');
      print(e);
      return null;
    } finally {
      client.close();
    }
  }
}
