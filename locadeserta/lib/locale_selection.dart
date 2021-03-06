import 'package:flutter/material.dart';
import 'package:locadeserta/loaders/url_parser.dart';
import 'package:locadeserta/models/app_preferences.dart';

class LocaleSelection extends StatefulWidget {
  final Function(Locale locale) onLocaleChanged;
  final Locale locale;

  LocaleSelection({required this.locale, required this.onLocaleChanged});
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
      children: [
        Radio(
          value: 'uk',
          groupValue: widget.locale.languageCode,
          onChanged: _setNewLocale,
        ),
        Text('UA'),
        Radio(
          value: 'en',
          groupValue: widget.locale.languageCode,
          onChanged: _setNewLocale,
        ),
        Text('ENG'),
      ],
    );
  }

  void _setNewLocale(String? newValue) async {
    if (newValue == null) {
      return;
    }
    UrlParser.updateLanguage(newValue);
    await AppPreferences.instance.setUILanguage(newValue);
    widget.onLocaleChanged(Locale(newValue));
  }
}
