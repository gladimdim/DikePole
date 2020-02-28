import 'package:flutter/widgets.dart';

class FullWidth extends StatelessWidget {
  final Widget child;

  FullWidth({this.child});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}
