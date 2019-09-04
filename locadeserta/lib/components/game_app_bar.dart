import 'package:flutter/material.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/models/Localizations.dart';

class GameAppBar extends StatelessWidget {
  final VoidCallback onResetStory;
  final VoidCallback onExportStory;
  final String title;

  GameAppBar({this.onResetStory, this.onExportStory, @required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBarCustom(
      title: title,
      appBarButtons: [
        AppBarObject(
          onTap: () => Navigator.pop(context),
          text: LDLocalizations.of(context).backToStories,
        ),
        AppBarObject(
          onTap: onResetStory,
          text: LDLocalizations.of(context).reset,
        ),
        AppBarObject(
          onTap: onExportStory,
          text: LDLocalizations.of(context).shareStory,
        ),
      ],
    );
  }
}
