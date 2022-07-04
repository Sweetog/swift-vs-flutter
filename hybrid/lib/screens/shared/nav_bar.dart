import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/account/account.dart';
import 'package:hybrid/screens/courses/courses.dart';
import 'package:hybrid/screens/home/home.dart';

final Color _iconColor = BmsColors.primaryForeground;
final TextStyle _navBarItemTxtStyle = TextStyle(
    fontFamily: 'Lalezar',
    color: BmsColors.primaryForeground,
    fontSize: 15.0);

class NavBar extends StatefulWidget {
  final int index;

  NavBar({@required this.index});

  @override
  State<StatefulWidget> createState() => _NavBarState(index: index);
}

class _NavBarState extends State<NavBar> {
  int index;

  _NavBarState({@required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: BmsColors.verdantGoldBlack,
      currentIndex: (index == null) ? 0 : index,
      onTap: (int index) {
        if(this.index == index) {
          return;
        }
        setState(() {
          this.index = index;
        });
        _navigateToScreens(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.home,
            color: _iconColor,
          ),
          title: new Text(
            'Home',
            style: _navBarItemTxtStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.golf_course,
            color: _iconColor,
          ),
          title: new Text(
            'Courses',
            style: _navBarItemTxtStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: _iconColor,
          ),
          title: Text(
            'Account',
            style: _navBarItemTxtStyle,
          ),
        ),
      ],
    );
  }

  _navigateToScreens(int indx) {
    switch (index) {
      case NavBarIndex.Home:
        UIUtil.navigateAsRoot(Home(), context);
        break;
      case NavBarIndex.Courses:
        UIUtil.navigateAsRoot(Courses(), context);
        break;
      case NavBarIndex.Account:
        UIUtil.navigateAsRoot(Account(), context);
        break;
    }
  }
}
