import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/util/format_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';

final _selectedTxtStyleTitle3 = UIUtil.createTxtStyle(UIUtil.txtSizeTitle3,
    color: BmsColors.primaryBackground);
final _selectedListTileSubtitileStyle = UIUtil.createTxtStyle(
    UIUtil.txtSizeCaption2,
    color: BmsColors.primaryBackground);

class ContestCard extends StatelessWidget {
  final ContestModel contestModel;
  final VoidCallback onTap;
  final bool selected;

  ContestCard({@required this.contestModel, this.onTap, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: (selected)
          ? BmsColors.funZoneOrange
          : BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        selected: true,
        title: Text(
          contestModel.name,
          style:
              (selected) ? _selectedTxtStyleTitle3 : UIUtil.getTxtStyleTitle3(),
        ),
        subtitle: Text(
          contestModel.payoutLabel,
          style: (selected)
              ? _selectedListTileSubtitileStyle
              : UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Image(
          width: 32,
          image: AssetImage('assets/icon-app.png'),
        ),
        trailing: Text(
          FormatUtil.formatCurrencyInt(contestModel.payout),
          style: (selected)
              ? _selectedTxtStyleTitle3
              : UIUtil.getContestPrizeStyle(),
        ),
        onTap: onTap,
      ),
    );
  }
}
