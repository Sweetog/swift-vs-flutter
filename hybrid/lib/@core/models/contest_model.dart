import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContestModel {
  final String id;
  final String name;
  final int amount;
  final int payout;
  final String payoutLabel;
  final Timestamp startDate;
  final Timestamp endDate;
  final String courseId;
  final List<ContestModel> contests;

  ContestModel(
      {@required this.id,
      @required this.name,
      @required this.amount,
      @required this.payout,
      @required this.payoutLabel,
      @required this.startDate,
      @required this.endDate,
      @required this.courseId,
      @required this.contests});

  ContestModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        amount = json['amount'],
        payout = json['payout'],
        payoutLabel = json['payoutLabel'],
        startDate = _timestampFromJson(json['startDate']),
        endDate = _timestampFromJson(json['endDate']),
        courseId = json['courseId'],
        contests = _buildContests(json['contests']);

  static Timestamp _timestampFromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return Timestamp(json['_seconds'], json['_nanoseconds']);
  }

  static List<ContestModel> _buildContests(List<dynamic> json) {
    if (json == null || json.length <= 0) {
      return null;
    }
    var ret = List<ContestModel>();
    for (var i = 0; i < json.length; i++) {
      ret.add(ContestModel.fromJson(json[i]));
    }
    return ret;
  }
}
