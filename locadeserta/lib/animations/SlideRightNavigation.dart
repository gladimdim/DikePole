import 'package:flutter/material.dart';

class SlideRightNavigation extends PageRouteBuilder {
  final Widget widget;

  SlideRightNavigation({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
                return new SlideTransition(position: Tween(
                  begin: Offset.fromDirection(0.8), // 45 degrees down
                  end: Offset.zero,
                ).animate(animation),
                  child: child,);
        });
}
