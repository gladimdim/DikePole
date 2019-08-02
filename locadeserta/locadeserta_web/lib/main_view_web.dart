import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/animations/slideable_button_web.dart';
import 'package:locadeserta_web/components/about.dart';
import 'package:locadeserta_web/components/components.dart';
import 'package:locadeserta_web/models/localizations_web.dart';
import 'package:locadeserta_web/locale_selection_web.dart';

class MainView extends StatefulWidget {
  final Function onSetLocale;
  final Locale locale;
  LDLocalizations localization;

  MainView({this.onSetLocale, this.locale}) {
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
        Expanded(
          child: About(
            widget.localization,
          ),
        ),
        SlideableButton(
          child: optionBox(
            context,
            "Почати",
          ),
          onPress: () {
            Navigator.pushNamed(context, "/play");
          },
        ),
        Center(
          child: Text(
            widget.localization.versionLabel,
          ),
        ),
      ],
    );
  }

  _setNewLocale(Locale locale) {
    widget.onSetLocale(locale);
  }
}
