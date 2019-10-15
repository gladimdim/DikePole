import 'package:flutter/material.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/StatisticsView.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/creator/components/catalog_view.dart';
import 'package:onlineeditor/locale_selection_view.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.appTitle,
      body: Column(children: [
        LocaleSelection(
          onLocaleChanged: (newLocale) {
            LDLocalizations.locale = newLocale;
            setState(() {});
          },
        ),
        Expanded(child: CatalogGladStoryView()),
      ]),
      actions: [
        AppBarObject(
            text: LDLocalizations.statisticsTitle,
            onTap: () => {
                  Navigator.pushNamed(context, StatisticsView.routeName),
                })
      ],
    );
  }
}
