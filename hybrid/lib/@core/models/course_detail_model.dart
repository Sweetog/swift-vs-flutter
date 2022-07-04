
import 'package:flutter/material.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/models/course_model.dart';

class CourseDetailModel {
  final CourseModel course;
  final List<ContestModel> contests;

  CourseDetailModel({@required this.course, @required this.contests});
}