import 'package:flutter/material.dart';
import 'package:hybrid/@core/models/purchase_model.dart';
import 'package:hybrid/@core/models/user_model.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum UserStatus {
  UserCreated,
  UserCreationError,
  UserClaimCreated,
  UserClaimCreationError
}

class UserService {
  static final url = env.baseUrl;

  static Future<UserStatus> createUser(
      String name,
      String email,
      String password,
      String courseId,
      String memberNumber,
      String role) async {
    var functionName = 'user';
    var client = http.Client();
    var body = {
      'name': name,
      'email': email,
      'password': password,
      'courseId': courseId,
      'memberNumber': memberNumber,
      'role': role
    };
    try {
      print('user post request body: $body');
      var headers = await HttpUtil.getHeaders();
      var response = await client.post(url + '/v2/$functionName',
          headers: headers, body: json.encode(body));
      print('user post response: ${response.body}');
      return UserStatus.UserCreated;
    } catch (e) {
      print('caught http exception');
      print(e);
      return UserStatus.UserCreationError;
    } finally {
      client.close();
    }
  }

  static Future<UserModel> getUser(String uid) async {
    var functionName = 'user';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var response = await client.get(url + '/v2/$functionName?uid=$uid',
          headers: headers);

      if (response.body == null || response.body.isEmpty) {
        print('no response get user');
        return null;
      }

      print('get user: ${response.body}');
      var jsonRes = json.decode(response.body);
      return UserModel.fromJson(jsonRes);
    } catch (e) {
      print('caught http exception');
      print(e);
      return null;
    } finally {
      client.close();
    }
  }
}
