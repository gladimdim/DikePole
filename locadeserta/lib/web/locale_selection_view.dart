import 'package:flutter/material.dart';
import 'package:locadeserta/models/Localizations.dart';

class LocaleSelection extends StatefulWidget {
  final Function(Locale locale) onLocaleChanged;

  LocaleSelection({this.onLocaleChanged});
  @override
  _LocaleSelectionState createState() => _LocaleSelectionState();
}

class _LocaleSelectionState extends State<LocaleSelection> {
  @override
  Widget build(BuildContext context) {
    return _buildLocaleSelection(context);
  }

  Widget _buildLocaleSelection(BuildContext context) {
    final languageCode = LDLocalizations.locale.languageCode;
    var isLarge = MediaQuery.of(context).size.width > 500;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 'uk',
          groupValue: languageCode,
          onChanged: _setNewLocale,
        ),
        Row(
          children: <Widget>[
            Text('🇺🇦', style: TextStyle(fontSize: 24)),
            if (isLarge)
              Text("Українською",
                  style: TextStyle(color: Theme.of(context).accentColor)),
          ],
        ),
        Radio(
          value: 'pl',
          groupValue: languageCode,
          onChanged: _setNewLocale,
        ),
        Row(
          children: <Widget>[
            Text('🇵🇱', style: TextStyle(fontSize: 24)),
            if (isLarge)
              Text("Polski",
                  style: TextStyle(color: Theme.of(context).accentColor))
          ],
        ),
        Radio(
          value: 'en',
          groupValue: languageCode,
          onChanged: _setNewLocale,
        ),
        Row(
          children: <Widget>[
            Text('🇺🇸', style: TextStyle(fontSize: 24)),
            if (isLarge)
              Text("English",
                  style: TextStyle(color: Theme.of(context).accentColor))
          ],
        ),
      ],
    );
  }

  void _setNewLocale(String newValue) {
    widget.onLocaleChanged(Locale(newValue));
  }
}
