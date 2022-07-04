import 'package:flutter/material.dart';
import 'package:hybrid/screens/payment/shared/card_back_icon.dart';
import 'package:hybrid/screens/payment/shared/card_front_icon.dart';

enum CardAnimate { Front, Back }

class CardAnimator extends StatefulWidget {
  CardAnimator(
    Key key,
  ) : super(key: key);
  @override
  State<StatefulWidget> createState() => CardAnimatorState();
}

class CardAnimatorState extends State<CardAnimator>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _frontScale;
  Animation<double> _backScale;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _animationController,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _animationController,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          child: CardFrontIcon(),
          animation: _frontScale,
          builder: (BuildContext context, Widget child) {
            final Matrix4 transform = new Matrix4.identity()
              ..scale(1.0, _frontScale.value, 1.0);
            return new Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: child,
            );
          },
        ),
        AnimatedBuilder(
          child: CardBackIcon(),
          animation: _backScale,
          builder: (BuildContext context, Widget child) {
            final Matrix4 transform = Matrix4.identity()
              ..scale(1.0, _backScale.value, 1.0);
            return new Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: child,
            );
          },
        ),
      ],
    );
  }

  void animate() {
    if (_animationController.isCompleted || _animationController.velocity > 0) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}
