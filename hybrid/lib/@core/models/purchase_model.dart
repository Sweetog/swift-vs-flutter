import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/course_model.dart';

class PurchaseModel {
  final String id;
  final String userId;
  final String claimId;
  final ContestModel contest;
  final CourseModel course;
  final Timestamp timestamp;

  PurchaseModel(
      {@required this.id,
      @required this.userId,
      @required this.claimId,
      @required this.contest,
      @required this.course,
      @required this.timestamp});

  PurchaseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        claimId = json['claimId'],
        contest = ContestModel.fromJson(json['contest']),
        course = CourseModel.fromJson(json['course']),
        timestamp = _timestampFromJson(json['timestamp']);

  static Timestamp _timestampFromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return Timestamp(json['_seconds'], json['_nanoseconds']);
  }
}
