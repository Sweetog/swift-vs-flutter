import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/util/ui_util.dart';

class CourseHeaderFull extends StatelessWidget {
  final CourseModel courseModel;

  CourseHeaderFull({@required this.courseModel});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(courseModel.imageUrl), //maybe try Image.network to fix iOS
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: 140.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.5),
                ),
              ),
              Container(
                height: 120,
                child: Image(
                  color: BmsColors.primaryForeground,
                  image: NetworkImage(courseModel.logoUrl),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: BmsColors.primaryBackground),
            child: Center(
              child: Text(
                'Hole - ${courseModel.hole}    Par - ${courseModel.par}    HDCP - ${courseModel.handicap}',
                style: UIUtil.getTxtStyleTitle3(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}