import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/user_model.dart';
import 'package:hybrid/@core/models/user_stripe_model.dart';
import 'package:hybrid/@core/services/user_service.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/auth_util.dart';
import 'package:hybrid/@core/util/format_util.dart';
import 'package:hybrid/@core/util/http_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/account/add_funds.dart';
import 'package:hybrid/screens/account/contact_us.dart';
import 'package:hybrid/screens/account/contest_history.dart';
import 'package:hybrid/screens/account/logout.dart';
import 'package:hybrid/screens/payment/manage_payments.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

final _headerStyle = UIUtil.createTxtStyle(14, color: BmsColors.oldLogoGold);
var _usernameStyle = UIUtil.createTxtStyle(23);
var _memberSinceStyle = UIUtil.createTxtStyle(16);

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var _isDataRequestComplete;
  DateTime _memberDate;
  String _displayName;
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
    AuthUtil.getDisplayName().then((displayName) {
      AuthUtil.getCreatedDate().then((date) {
        setState(() {
          _isDataRequestComplete = true;
          _displayName = displayName;
          _memberDate = date;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Account),
    );
  }

  Widget _buildBody() {
    if (_isDataRequestComplete == null) {
      return Stack(children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Center(
          child: BmsProgressIndicator(),
        ),
      ]);
      //return Center(child: BmsProgressIndicator());
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, //probably not needed
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildProfileHeaderFuture(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('Payments & Winnings', style: _headerStyle),
                ),
                // GestureDetector(
                //   onTap: () {
                //     _navigateAddCredit(context);
                //   },
                //   child: _buildMenuItem('Add Funds', Icons.monetization_on),
                // ),
                GestureDetector(
                  onTap: () {
                    _navigateContestHistory(context);
                  },
                  child: _buildMenuItem('Claim Prize', Icons.golf_course),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateContestHistory(context);
                  },
                  child: _buildMenuItem('Contest History', Icons.book),
                ),
                // GestureDetector(
                //   onTap: () {
                //     print("Manage Payments Touched");
                //     _navigateManagePayments(context);
                //   },
                //   child: _buildMenuItem(
                //       'Manage Payments', Icons.account_balance_wallet),
                // ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('Account', style: _headerStyle),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateContactUs(context);
                  },
                  child: _buildMenuItem('Contact Us', Icons.contact_mail),
                ),
                GestureDetector(
                  onTap: () => HttpUtil.launchTerms(),
                  child: _buildMenuItem('Terms & Conditions', Icons.public),
                ),
                GestureDetector(
                  onTap: () => HttpUtil.launchContestRules(),
                  child: _buildMenuItem('Contest Rules', Icons.pages),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateLogout(context);
                  },
                  child: _buildMenuItem('Logout', Icons.low_priority),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    var menuTitleStyle = UIUtil.getTxtStyleCaption1();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: BmsColors.primaryBackground,
        border: Border(
          bottom: BorderSide(
            //                   <--- left side
            color: BmsColors.oldLogoGold,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(title, style: menuTitleStyle),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
            ),
          ),
          Icon(
            icon,
            size: 22.0,
            color: BmsColors.primaryForeground,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderFuture() {
    //return _buildProfileHeader();
    return FutureBuilder(
        future: _getUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildProfileHeader();
          }

          _userModel = snapshot.data;
          return _buildProfileHeader();
        });
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(color: BmsColors.primaryBackground),
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          _profileCircle(),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _displayName,
                  style: _usernameStyle,
                ),
                Text(
                  'Member Since ${_memberDate.year}',
                  style: _memberSinceStyle,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          (_userModel == null)
              ? Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: BmsProgressIndicator())
              : Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Credits',
                        style: UIUtil.getListTileSubtitileStyle(),
                      ),
                      Text(
                        FormatUtil.formatCredit(_userModel.accountBalance),
                        style: UIUtil.getContestPrizeStyle(),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _profileCircle() {
    var letterStyle =
        UIUtil.createTxtStyle(32.0, color: BmsColors.verdantGoldBlack);
    return RawMaterialButton(
      onPressed: () {
        print('account profile circle touch');
      },
      child: Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text(
          '${_displayName[0].toUpperCase()}',
          style: letterStyle,
        ),
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: BmsColors.primaryForeground,
      padding: const EdgeInsets.all(15.0),
    );
  }

  _getUser() async {
    var result = await AuthUtil.getCurrentUser();
    return UserService.getUser(result.uid);
  }

  void _navigateLogout(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Logout()),
    );
  }

  void _navigateManagePayments(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManagePayments()),
    );
  }

  void _navigateContestHistory(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContestHistory()),
    );
  }

  void _navigateContactUs(BuildContext context) async {
    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactUs()),
    );
  }

  // void _navigateAddCredit(BuildContext context) async {
  //   if (_userModel == null) {
  //     return;
  //   }

  //   bool _ = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => AddFunds(
  //               model: UserStripeModel(stripeCustomerId: 'sdsd', accountBalance: -1000),
  //             )),
  //   );
  // }
}
