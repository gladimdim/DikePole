import 'package:flutter/material.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/other_game.dart';

class OtherGamesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(LDLocalizations.labelOtherGames),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: OtherGame.allGames().map((game) {
          var gameTitle = LDLocalizations.getForKey(game.titleKey);
          return InkWell(
            onTap: () {
              var locale = LDLocalizations.locale;
              game.openUrlFor(locale);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(game.image, width: 46),
                Text(gameTitle!),
              ],
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
