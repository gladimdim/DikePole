import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/constants.dart';

class NarrowScaffold extends StatefulWidget {
  final Widget body;
  final List<AppBarObject> actions;
  final String title;
  final showBackButton;

  NarrowScaffold({
    this.body,
    this.actions,
    @required this.title,
    this.showBackButton = true,
  });

  @override
  _NarrowScaffoldState createState() => _NarrowScaffoldState();
}

class _NarrowScaffoldState extends State<NarrowScaffold> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: APP_BAR_HEIGHT + 8),
                child: widget.body,
              ),
              if (expanded)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: new BackdropFilter(
                    filter: new ui.ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: new Container(
                      //you can change opacity with color here(I used black) for background.
                      decoration: new BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Container(child: GestureDetector(onTap: () {
                        setState(() {
                          expanded = false;
                        });
                      })),
                    ),
                  ),
//              child: Opacity(
//                opacity: 0.8,
//                child: Container(
//                  color: Colors.black,
//                  child: GestureDetector(
//                    onTap: () {
//                      setState(() {
//                        expanded = false;
//                      });
//                    }
//                  )
//                ),
//              ),
                ),
              AppBarCustom(
                title: widget.title,
                appBarButtons: widget.actions,
                expanded: expanded,
                showBackButton: widget.showBackButton,
                onExpanded: (expand) {
                  setState(() {
                    expanded = expand;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
