import 'package:flutter_web/material.dart';

class LocaleSelection extends StatefulWidget {
  final Function(Locale locale) onLocaleChanged;
  final Locale locale;

  LocaleSelection({this.locale, this.onLocaleChanged});
  @override
  _LocaleSelectionState createState() => _LocaleSelectionState();
}

class _LocaleSelectionState extends State<LocaleSelection> {
  @override
  Widget build(BuildContext context) {
    return _buildLocaleSelection(context);
  }

  Widget _buildLocaleSelection(BuildContext context) {
    final languageCode = widget.locale.languageCode;
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
            if (isLarge) Text("Українською", style: TextStyle(color: Theme.of(context).textTheme.title.color))
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
            if (isLarge) Text("Polski", style: TextStyle(color: Theme.of(context).textTheme.title.color))
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
            if (isLarge) Text("English", style: TextStyle(color: Theme.of(context).textTheme.title.color))
          ],
        ),
      ],
    );
  }

  void _setNewLocale(String newValue) {
    widget.onLocaleChanged(Locale(newValue));
  }
}
