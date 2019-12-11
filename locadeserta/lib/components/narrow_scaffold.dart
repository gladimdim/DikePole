import 'package:flutter/material.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/constants.dart';

class NarrowScaffold extends StatelessWidget {
  final Widget body;
  final List<AppBarObject> actions;
  final String title;

  NarrowScaffold({this.body, this.actions, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: APP_BAR_HEIGHT + 8),
            child: body,
          ),
          AppBarCustom(
            title: title,
            appBarButtons: actions,
          ),
        ]),
      ),
    );
  }
}
