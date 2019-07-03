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
    return _buildLocaleSelection();
  }

  Widget _buildLocaleSelection() {
    final languageCode = widget.locale.languageCode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 'uk',
          groupValue: languageCode,
          onChanged: _setNewLocale,
        ),
        Text('🇺🇦'),
        Radio(
          value: 'pl',
          groupValue: languageCode,
          onChanged: _setNewLocale,
        ),
        Text('🇵🇱'),
        Radio(
          value: 'en',
          groupValue: languageCode,
          onChanged: _setNewLocale,
        ),
        Text('🇺🇸'),
      ],
    );
  }

  void _setNewLocale(String newValue) {
    widget.onLocaleChanged(Locale(newValue));
  }
}
