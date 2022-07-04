import 'package:flutter/material.dart';
import 'package:hybrid/@core/bms_colors.dart';
import 'package:hybrid/@core/util/ui_util.dart';

const _creditCardIconWidth = 200.0;
const _creditCardIconHeight = 118.0;
const _creditCardBorderRadius = 15.0;
const _dotPadding = 3.0;
const _dotSetPadding = 8.0;
const _dotWidth = 5.0;
const _dotHeight = 5.0;

class CardFrontIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCreditCardIcon();
  }

  Widget _buildCreditCardIcon() {
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
          left: 15.0,
          top: 15.0,
          width: 35.0,
          height: 35.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          left: 18.0,
          bottom: 25.0,
          child: Row(
            children: <Widget>[
              _buildDotSet(),
              _buildDotSet(),
              _buildDotSet(),
              _buildDotSet(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDotSet() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: _dotSetPadding),
          child: _buildDot(),
        ),
        Padding(
          padding: EdgeInsets.only(left: _dotPadding),
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
