import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';

class SoftContainer extends StatelessWidget {
  final Widget child;
  final bool onlyTop;
  final double borderRadiusValue;

  const SoftContainer(
      {Key key,
      this.child,
      this.onlyTop = false,
      this.borderRadiusValue = 40.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: ClayContainer(
          child: child,
          color: Theme.of(context).backgroundColor,
          borderRadius: 15,
        ),
      ),
    );
  }
}
