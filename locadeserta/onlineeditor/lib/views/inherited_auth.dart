import 'package:flutter/material.dart';
import 'package:onlineeditor/models/LDAuth.dart';

class InheritedAuth extends InheritedWidget {
  final LDAuth auth;
  final Widget child;
  InheritedAuth({this.auth, this.child}) : super(child: child);

  @override
  updateShouldNotify(oldWidget) => true;

  static InheritedAuth of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedAuth) as InheritedAuth;
  }
}
