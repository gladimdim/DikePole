import 'package:flutter/material.dart' as slide_right_navigation;

class SlideRightNavigation extends slide_right_navigation.PageRouteBuilder {
  final slide_right_navigation.Widget widget;

  SlideRightNavigation({this.widget})
      : super(pageBuilder: (slide_right_navigation.BuildContext context, slide_right_navigation.Animation<double> animation,
            slide_right_navigation.Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (slide_right_navigation.BuildContext context,
            slide_right_navigation.Animation<double> animation,
            slide_right_navigation.Animation<double> secondaryAnimation,
            slide_right_navigation.Widget child) {
                return new slide_right_navigation.SlideTransition(position: slide_right_navigation.Tween(
                  begin: slide_right_navigation.Offset.fromDirection(0.8), // 45 degrees down
                  end: slide_right_navigation.Offset.zero,
                ).animate(animation),
                  child: child,);
        });
}
