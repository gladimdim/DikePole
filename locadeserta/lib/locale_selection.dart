import 'package:flutter/material.dart';
import 'package:locadeserta/loaders/url_parser.dart';

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
    return _buildLocaleSelection();
  }

  Widget _buildLocaleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Radio(
          value: 'uk',
          groupValue: widget.locale.languageCode,
          onChanged: _setNewLocale,
        ),
        Text('🇺🇦'),
        Radio(
          value: 'en',
          groupValue: widget.locale.languageCode,
          onChanged: _setNewLocale,
        ),
        Text('🇺🇸'),
      ],
    );
  }

  void _setNewLocale(String newValue) {
    UrlParser.updateLanguage(newValue);
    widget.onLocaleChanged(Locale(newValue));
  }
}
