import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/constants/nav_bar_index.dart';
import 'package:hybrid/@core/models/purchase_model.dart';
import 'package:hybrid/@core/services/purchase_service.dart';
import 'package:hybrid/@core/ui-components/progress_indicator.dart';
import 'package:hybrid/@core/util/format_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/claim/claim_combo.dart';
import 'package:hybrid/screens/claim/claim_start.dart';
import 'package:hybrid/screens/shared/app_bar.dart';
import 'package:hybrid/screens/shared/nav_bar.dart';
import 'package:hybrid/screens/shared/scroll_behavior.dart';

const _validClaimHours = 24.0;

class ContestHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContestHistoryState();
}

class _ContestHistoryState extends State<ContestHistory> {
  List<PurchaseModel> _purchases;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PurchaseService.getPurchases(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          _purchases = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: BmsAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavBar(index: NavBarIndex.Account),
    );
  }

  Widget _buildBody() {
    if (_purchases == null) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: UIUtil.getDecorationBg(),
          ),
          Center(
            child: BmsProgressIndicator(),
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: UIUtil.getDecorationBg(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: BmsColors.primaryBackground,
              child: ListTile(
                title: Text(
                  'Contest History',
                  style: UIUtil.getTxtStyleTitle3(),
                ),
                subtitle: Text(
                  'These are the contests you have entered in the past, touch a contest to start a claim.',
                  style: UIUtil.getListTileSubtitileStyle(),
                ),
                leading: Icon(
                  Icons.history,
                  color: BmsColors.primaryForeground,
                ),
              ),
            ),
            _buildPurchasesListView(),
          ],
        ),
      ],
    );
  }

  Widget _buildPurchasesListView() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: (_purchases != null) ? _purchases.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (_purchases[index].claimId != null) {
                  _showInSnackBar(
                    'You have already started a claim for this contest.',
                    Duration(seconds: 10),
                  );
                  return;
                }

                if (!canMakeClaim(_purchases[index].timestamp)) {
                  _showInSnackBar(
                    'Time has exceeded. You have to start your claim in ${_validClaimHours.toStringAsFixed(0)} hours.',
                    Duration(seconds: 10),
                  );
                  return;
                }

                _navigateClaim(context, _purchases[index]);
              },
              child: Card(
                color: BmsColors.primaryBackground,
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                    _purchases[index].contest.name,
                    style: UIUtil.getTxtStyleTitle3(),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${_getFormattedPurchaseDate(_purchases[index].timestamp)}',
                        style: UIUtil.getListTileSubtitileStyle(),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Hole ${_purchases[index].course.hole}',
                        style: UIUtil.getListTileSubtitileStyle(),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '${_purchases[index].course.name}',
                        style: UIUtil.getListTileSubtitileStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  leading: Icon(
                    Icons.golf_course,
                    size: 32,
                    color: BmsColors.primaryForeground,
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Text(
                        FormatUtil.formatCurrencyInt(
                            _purchases[index].contest.payout),
                        style: UIUtil.getContestPrizeStyleSmall(),
                      ),
                      Text(
                        _purchases[index].contest.payoutLabel,
                        style: UIUtil.getTxtStyleCaption2(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getFormattedPurchaseDate(Timestamp timestamp) {
    return FormatUtil.formatDateDefault(timestamp.toDate());
  }

  bool canMakeClaim(Timestamp timestamp) {
    var diff = DateTime.now().difference(timestamp.toDate()).inHours;
    return diff <= _validClaimHours;
  }

  void _showInSnackBar(String value, Duration duration) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(
          value,
          style: UIUtil.getTxtStyleSnackBar(),
        ),
        duration: duration));
  }

  void _hideSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  void _navigateClaim(BuildContext context, PurchaseModel model) async {
    if (model.contest.contests != null && model.contest.contests.length > 0) {
      bool _ = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClaimCombo(model: model)),
      );
      return;
    }

    bool _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClaimStart(purchaseModel: model)),
    );
  }
}
