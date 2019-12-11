import 'package:flutter/material.dart';
import 'package:locadeserta/components/appbar_button.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/button_text_icon.dart';
import 'package:locadeserta/models/Localizations.dart';

class AppBarCustom extends StatefulWidget {
  final String title;
  final List<AppBarObject> appBarButtons;

  AppBarCustom({@required this.appBarButtons, @required this.title});

  @override
  _AppBarCustomState createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var menuIcon = expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    return Positioned(
      top: 0,
      left: 0.0,
      right: 0,
      child: BorderedContainer(
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          color: Theme.of(context).backgroundColor,
          height: expanded
              ? (widget.appBarButtons.length * 50).toDouble() + 40
              : 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Theme.of(context).textTheme.title.fontSize,
                        color: Theme.of(context).textTheme.title.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonTextIcon(
                    text: LDLocalizations.menuText,
                    onTap: _toggleExpandedMenu,
                    icon: Icon(
                      menuIcon,
                    ),
                  ),
                ],
              ),
              if (expanded)
                SizedBox(
                  height: (widget.appBarButtons.length * 50).toDouble(),
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: widget.appBarButtons
                        .map((obj) => _appBarObjectToButton(obj, context))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarObjectToButton(AppBarObject object, BuildContext context) {
    return AppBarButton(
      onTap: _callbackerHandler(object.onTap),
      text: object.text,
      color: Theme.of(context).textTheme.title.color,
    );
  }

  _toggleExpandedMenu() {
    setState(() {
      expanded = !expanded;
    });
  }

  _callbackerHandler(VoidCallback callback) {
    return () {
      _toggleExpandedMenu();
      callback();
    };
  }
}

class AppBarObject {
  final VoidCallback onTap;
  final String text;

  AppBarObject({@required this.text, @required this.onTap});
}
