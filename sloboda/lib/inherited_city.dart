import 'package:flutter/material.dart';
import 'package:sloboda/models/sloboda.dart';

class InheritedCity extends InheritedWidget {
  final Widget child;
  final Sloboda city;
  InheritedCity({this.city, this.child}) : super(child: child);

  @override
  updateShouldNotify(oldWidget) => true;

  static InheritedCity of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedCity) as InheritedCity;
  }
}
