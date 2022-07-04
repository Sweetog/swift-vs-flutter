import 'package:flutter/widgets.dart';

class CourseModel {
  final String id;
  final String imageUrl;
  final int handicap;
  final int hole;
  final String name;
  final int par;
  final String logoUrl;
  final String teeBoxLabel;

  CourseModel({@required this.id, @required this.imageUrl, @required this.handicap, @required this.hole, @required this.name, @required this.par, @required this.logoUrl, @required this.teeBoxLabel});

  CourseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageUrl = json['imageUrl'],
        handicap = json['handicap'],
        hole = json['hole'],
        name = json['name'],
        par = json['par'],
        logoUrl = json['logoUrl'],
        teeBoxLabel = json['teeBoxLabel'];
}

