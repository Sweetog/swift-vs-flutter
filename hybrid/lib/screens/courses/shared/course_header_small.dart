import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/models/course_model.dart';
import 'package:hybrid/@core/util/ui_util.dart';

class CourseHeaderSmall extends StatelessWidget {
  final CourseModel courseModel;

  CourseHeaderSmall({@required this.courseModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Hole - ${courseModel.hole}    Par - ${courseModel.par}    HDCP - ${courseModel.handicap}',
          style: UIUtil.getTxtStyleTitle3(),
        ),
        subtitle: Text(
          'Valid Tee Boxes: ${courseModel.teeBoxLabel}', // \n Must play today, video verified.
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Image(
          color: BmsColors.primaryForeground,
          image: NetworkImage(courseModel.logoUrl),
        ),
      ),
    );
  }
}
