import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';

const _creditCardIconWidth = 200.0;
const _creditCardIconHeight = 118.0;
const _creditCardBorderRadius = 15.0;
const _dotPadding = 3.0;
const _dotWidth = 5.0;
const _dotHeight = 5.0;

class CardBackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCreditCardIconBack();
  }

  Widget _buildCreditCardIconBack() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox(
          height: _creditCardIconHeight,
          width: _creditCardIconWidth,
          child: Container(
            decoration: BoxDecoration(
              color: BmsColors.primaryBackground,
              border: Border.all(
                  color: BmsColors.primaryForeground, width: 2.0),
              borderRadius: BorderRadius.circular(_creditCardBorderRadius),
            ),
          ),
        ),
        SizedBox(
          height: _creditCardIconHeight - 12.0,
          width: _creditCardIconWidth - 12.0,
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: BmsColors.primaryBackground,
              border: Border.all(
                  color: BmsColors.primaryForeground, width: 0.5),
              borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
            ),
          ),
        ),
        Positioned(
          top: 22.0,
          left: 0.0,
          child: SizedBox(
            width: _creditCardIconWidth,
            height: 20,
            child: Container(
              child: _buildCcvDotSet(),
              decoration: new BoxDecoration(
                color: BmsColors.primaryForeground,
              ),
            ),
          ),
        ),
        Positioned(
          right: 15.0,
          bottom: 15.0,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Container(
              child: _buildCcvDotSet(),
              decoration: new BoxDecoration(
                border: Border.all(
                    color: BmsColors.primaryForeground, width: 2.0),
                color: BmsColors.primaryBackground,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCcvDotSet() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: _buildDot(),
        ),
        Padding(
          padding: EdgeInsets.only(left: _dotPadding),
          child: _buildDot(),
        ),
        Padding(
          padding: EdgeInsets.only(left: _dotPadding),
          child: _buildDot(),
        )
      ],
    );
  }

  Widget _buildDot() {
    return SizedBox(
      width: _dotWidth,
      height: _dotHeight,
      child: Container(
        decoration: BoxDecoration(
          color: BmsColors.primaryForeground,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
