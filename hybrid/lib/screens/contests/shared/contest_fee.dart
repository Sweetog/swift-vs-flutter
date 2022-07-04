import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/models/contest_model.dart';
import 'package:hybrid/@core/util/format_util.dart';
import 'package:hybrid/@core/util/ui_util.dart';

class ContestFee extends StatelessWidget {
  final ContestModel contestModel;

  ContestFee({@required this.contestModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'Contest Fee',
          style: UIUtil.getTxtStyleTitle3(),
        ),
        subtitle: Text(
          'The Cost of Entry for this Contest.',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: Icon(
          Icons.monetization_on,
          color: BmsColors.primaryForeground,
        ),
        trailing: Text(FormatUtil.formatCurrencyInt(contestModel.amount),
            style: UIUtil.getContestPrizeStyle()),
      ),
    );
  }
}
