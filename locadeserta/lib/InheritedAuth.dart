import 'package:flutter/material.dart';
import 'package:locadeserta/models/Auth.dart';

class InheritedAuth extends InheritedWidget {
  final Auth auth;
  final Widget child;
  InheritedAuth({this.auth, this.child}) : super(child: child);

  @override
  updateShouldNotify(oldWidget) => true;

  static InheritedAuth of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedAuth) as InheritedAuth;
  }
}
