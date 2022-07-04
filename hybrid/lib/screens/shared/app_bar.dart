import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/screens/shared/app_title.dart';

class BmsAppBar extends StatelessWidget with PreferredSizeWidget {
    final bool automaticallyImplyLeading;

    BmsAppBar({this.automaticallyImplyLeading = true});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      title: AppTitle(),
      iconTheme: IconThemeData(
        color: BmsColors.primaryForeground,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
