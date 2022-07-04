import 'package:flutter/material.dart';

class UserModel {
  final double accountBalance;
  final String phone;
  final String lastCourseId;
  final List<String> courseIds;

  UserModel(
      {@required this.accountBalance,
      @required this.phone,
      @required this.lastCourseId,
      @required this.courseIds});

  UserModel.fromJson(Map<String, dynamic> json)
      : accountBalance = -1.0 * (json['accountBalance'] ?? 0),
        phone = json['phone'],
        lastCourseId = json['lastCourseId'],
        courseIds = _buildCourseIds(json['courseIds']);

  static List<String> _buildCourseIds(List<dynamic> json) {
    if (json == null || json.length <= 0) {
      return null;
    }
    var ret = List<String>();
    for (var i = 0; i < json.length; i++) {
      ret.add(json[i]);
    }
    return ret;
  }
}
