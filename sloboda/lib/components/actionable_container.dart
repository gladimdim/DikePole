import 'package:flutter/widgets.dart';

class ActionableContainer extends StatelessWidget {
  final Widget child;

  ActionableContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Center(child: child),
    );
  }
}
