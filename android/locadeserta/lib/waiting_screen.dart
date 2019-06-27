import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/radiuses.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.5;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              LDLocalizations.of(context).lookingForHeroes,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Hero(
              tag: "CossackHero",
              child: ClipRRect(
                borderRadius: getAllRoundedBorderRadius(),
                child: TweenImage(
                  last: AssetImage("images/background/cossack_0.jpg"),
                  first: AssetImage("images/background/c_cossack_0.jpg"),
                  duration: 2,
                  height: height,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
