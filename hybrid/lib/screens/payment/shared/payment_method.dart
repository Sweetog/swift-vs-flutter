import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';
import 'package:hybrid/screens/payment/shared/card_utils.dart';

class PaymentMethod extends StatelessWidget {
  final String last4;
  final String brandDisplay;
  final CardType cardType;
  final bool isDefault;
  final String subTitle;

  PaymentMethod(
      {@required this.last4,
      @required this.brandDisplay,
      @required this.cardType,
      @required this.isDefault,
      this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BmsColors.primaryBackground,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          'xxxx-$last4',
          style: UIUtil.getTxtStyleCaption1(),
        ),
        subtitle: Text(
          (subTitle != null) ? subTitle : (isDefault) ? 'Your Default Payment Method' : 'Stored Payment Method, Swipe Left to Delete',
          style: UIUtil.getListTileSubtitileStyle(),
        ),
        leading: CardUtils.getCardIcon(cardType),
        trailing: (isDefault)
            ? Icon(
                Icons.check_circle,
                size: 32,
                color: BmsColors.primaryForeground,
              )
            : Container(
                width: 32,
              ),
      ),
    );
  }
}
