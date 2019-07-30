import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/components/about.dart';
import 'package:locadeserta_web/models/localizations_web.dart';
import 'package:locadeserta_web/locale_selection_web.dart';

class MainView extends StatefulWidget {
  final VoidCallback onContinue;
  final Function onSetLocale;
  final Locale locale;
  LDLocalizations localization;

  MainView({this.onContinue, this.onSetLocale, this.locale}) {
    localization = LDLocalizations(locale);
  }

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LocaleSelection(
          onLocaleChanged: _setNewLocale,
          locale: widget.locale,
        ),
        About(widget.localization),
        Center(
          child: Text("1.69"),
        ),
      ],
    );
  }

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }
}
