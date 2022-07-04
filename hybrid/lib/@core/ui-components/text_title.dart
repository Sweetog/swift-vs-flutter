import 'package:flutter/material.dart';
import 'package:hybrid/@core/util/ui_util.dart';

import '../bms_colors.dart';

class TextTitle extends StatelessWidget {
  final String data;
  TextTitle(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        data,
        style: UIUtil.getTxtStyleTitle3(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 2.0, color: BmsColors.primaryForeground),
        ),
      ),
    );
  }
}
