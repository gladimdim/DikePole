import 'package:flutter/material.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/components/appbar_button.dart';
import 'package:sloboda/components/button_text_icon.dart';

class AppBarCustom extends StatefulWidget {
  final String title;
  final Widget titleView;
  final List<AppBarObject> appBarButtons;
  final Function(bool expand) onExpanded;
  final bool expanded;

  AppBarCustom({
    this.appBarButtons = const [],
    @required this.title,
    this.onExpanded,
    this.titleView,
    this.expanded = false,
  });

  @override
  _AppBarCustomState createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  @override
  Widget build(BuildContext context) {
    var menuIcon =
        widget.expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    return Positioned(
      top: 0,
      left: 0.0,
      right: 0,
      child: SoftContainer(
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          color: Theme.of(context).backgroundColor,
          height: widget.expanded
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
                    child: widget.titleView != null
                        ? Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.85),
                            child: widget.titleView,
                          )
                        : Container(
                            constraints: BoxConstraints(minWidth: 200),
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                  if (widget.appBarButtons != null)
                    ButtonTextIcon(
                      text: 'Menu',
                      onTap: _toggleExpandedMenu,
                      icon: Icon(
                        menuIcon,
                      ),
                    ),
                ],
              ),
              if (widget.expanded)
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
      child: object.child,
      color: Theme.of(context).primaryColor,
    );
  }

  _toggleExpandedMenu() {
    widget.onExpanded(!widget.expanded);
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
  final Widget child;

  AppBarObject({@required this.child, @required this.onTap});
}
