import 'package:flutter/material.dart';
import 'package:locadeserta/components/appbar_button.dart';
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
      child: Container(
        color: Theme.of(context).primaryColor,
        height: expanded ? 80 : 32,
        child: Column(
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
                  text: LDLocalizations.of(context).menuText,
                  color: Colors.white,
                  onTap: _toggleExpandedMenu,
                  icon: Icon(
                    menuIcon,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (expanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                    widget.appBarButtons.map(_appBarObjectToButton).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _appBarObjectToButton(AppBarObject object) {
    return AppBarButton(
      onTap: _callbackerHandler(object.onTap),
      text: object.text,
      color: Colors.white,
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
