import 'package:cloud_firestore/cloud_firestore.dart';
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

class LandingView extends StatefulWidget {
  final Auth auth;

  LandingView({this.auth});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return _buildLandingListView(context);
  }

  _goToStory(CatalogStory story) async {
    var user = await widget.auth.currentUser();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StoryView(uid: user.uid, catalogStory: story)));
  }

  _onViewCatalogPressed(BuildContext context) async {
    final selectedStory = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CatalogView()));
    _goToStory(selectedStory);
  }

  ListView _buildLandingListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildCardWithImage(
            image: "images/background/landing/landing_3.jpg",
            coloredImage: 'images/background/landing/c_landing_3.jpg',
            mainText: LDLocalizations.of(context).youHaveSavedGame,
            buttonText: LDLocalizations.of(context).Continue,
            onButtonPress: () async {
              var user = await widget.auth.currentUser();
              DocumentReference userState = Firestore.instance
                  .collection("user_states")
                  .document(user.uid);
              DocumentSnapshot possibleStories = await userState.get();
              if (possibleStories.data != null) {
                var catalogStory = await CatalogStory.getStoryById(possibleStories["catalogidreference"]);
                _goToStory(catalogStory);
              }
            },
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
                  FlatButton(
                      onPressed: onButtonPress,
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ))
                ],
              ))
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
