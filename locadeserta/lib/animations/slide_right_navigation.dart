import 'package:flutter/material.dart' as material;

class SlideRightNavigation extends material.PageRouteBuilder {
  final material.Widget widget;

  SlideRightNavigation({this.widget})
      : super(
          pageBuilder: (material.BuildContext context,
              material.Animation<double> animation,
              material.Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (material.BuildContext context,
              material.Animation<double> animation,
              material.Animation<double> secondaryAnimation,
              material.Widget child) {
            return material.SlideTransition(
              position: material.Tween(
                begin: material.Offset.fromDirection(0.8),
                // 45 degrees down
                end: material.Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
