import 'package:flutter/material.dart';
import 'package:sloboda/components/app_bar_custom.dart';
import 'package:sloboda/components/constants.dart';
import 'dart:ui' as ui;

class NarrowScaffold extends StatefulWidget {
  final Widget body;
  final List<AppBarObject> actions;
  final String title;
  final Widget titleView;

  NarrowScaffold({
    this.body,
    this.actions,
    this.title,
    this.titleView,
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.only(top: APP_BAR_HEIGHT + 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.body,
                  ),
                ),
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
                titleView: widget.titleView,
                appBarButtons: widget.actions,
                expanded: expanded,
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
