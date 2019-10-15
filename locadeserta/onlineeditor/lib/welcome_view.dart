import 'package:flutter/material.dart';
import 'package:onlineeditor/locale_selection_view.dart';

class WelcomeView extends StatelessWidget {
  final Function onLocaleChanged;

  WelcomeView(this.onLocaleChanged);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        LocaleSelection(
          onLocaleChanged: onLocaleChanged,
        )
      ],
    );
  }
}
