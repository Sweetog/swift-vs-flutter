import 'package:flutter/material.dart';

const _totalCreateAccountSteps = 5;

class AccountHelper {
  static double getCreateAccountProgressWidth(BuildContext context, int step,
      {int totalSteps = _totalCreateAccountSteps}) {
    final double stepProgressBarPercentage = 1 / (totalSteps + 1);
    final double width = MediaQuery.of(context).size.width;
    return width * stepProgressBarPercentage * step;
  }
}
