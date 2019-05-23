import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';

import 'animations/TweenImage.dart';
import 'models/Localizations.dart';

const LANDING_IMAGE_HEIGHT = 200.0;

class MainMenu extends StatefulWidget {
  final Auth auth;

  MainMenu({this.auth});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool loadingStory = false;

  @override
  Widget build(BuildContext context) {
    return _buildLandingListView(context);
  }

  _goToStory(CatalogStory story, bool loadState) async {
    var user = await widget.auth.currentUser();
    setState(() {
      loadingStory = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryView(
                  user: user,
                  catalogStory: story,
                  loadState: loadState,
                )));
  }

  _onViewCatalogPressed(BuildContext context) async {
    final selectedStory = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CatalogView()));
    _goToStory(selectedStory, false);
  }

  ListView _buildLandingListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildCardWithImage(
            image: "images/background/landing/landing_3.jpg",
            coloredImage: 'images/background/landing/c_landing_3.jpg',
            mainText: LDLocalizations.of(context).youHaveSavedGame,
            buttonText: LDLocalizations.of(context).Continue,
            onButtonPress: _onContinuePressed,
            context: context),
        SizedBox(
          height: 20.0,
        ),
        _buildCardWithImage(
            image: "images/background/landing/landing_2.jpg",
            coloredImage: 'images/background/landing/c_landing_2.jpg',
            mainText: LDLocalizations.of(context).bookCatalog,
            buttonText: LDLocalizations.of(context).view,
            onButtonPress: () => _onViewCatalogPressed(context),
            context: context),
        Center(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "For Privacy Policy Tap here.",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () async {
              if (await canLaunch(
                  "https://locadeserta.com/privacy_policy.html")) {
                await launch("https://locadeserta.com/privacy_policy.html");
              }
            },
          ),
        ),
      ],
    );
  }

  _onContinuePressed() async {
    setState(() {
      loadingStory = true;
    });
    var user = await widget.auth.currentUser();
    var catalogStory = await CatalogStory.getCatalogStoryForUser(user);
    _goToStory(catalogStory, true);
  }

  Widget _buildCardWithImage(
      {String image,
      String coloredImage,
      String mainText,
      String buttonText,
      Function onButtonPress,
      @required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: _getTopRoundedBorderRadius()),
        child: Card(
          elevation: 0.0,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: _getTopRoundedBorderRadius(),
                ),
                child: ClipRRect(
                  borderRadius: _getTopRoundedBorderRadius(),
                  child: TweenImage(
                    first: AssetImage(image),
                    last: AssetImage(coloredImage),
                    duration: 2,
                  ),
                ),
              ),
              ListTile(
                  title: Text(
                mainText,
                style: TextStyle(fontSize: 20.0),
              )),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    if (loadingStory)
                      Text(LDLocalizations.of(context).loadingStory),
                    if (!loadingStory)
                      FlatButton(
                        onPressed: onButtonPress,
                        child: Text(
                          buttonText,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius _getTopRoundedBorderRadius() {
    return BorderRadius.only(
        topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));
  }
}
