import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:locadeserta/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locadeserta/story_view.dart';

class LandingView extends StatefulWidget {
  final Function(String json) onStartGamePressed;

  LandingView({this.onStartGamePressed});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  FirebaseUser authedUser;
  String userUid;

  @override
  Widget build(BuildContext context) {
    return _buildLandingListView(context);
  }

  _goToStory(String json) {
    var uid = authedUser == null ? userUid : authedUser.uid;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryView(uid: uid, storyJson: json)));
  }

  _onViewCatalogPressed(BuildContext context) async {
    final selectedStoryJsonString = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CatalogView()));
    _goToStory(selectedStoryJsonString);
  }

  ListView _buildLandingListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        LoginView(onUserLoggedIn: (FirebaseUser user, String uid) {
          if (user != null) {
            authedUser = user;
          }
          if (uid != null) {
            userUid = uid;
          }
        }),
        _buildCardWithImage(
          image: "images/background/landing_1.jpg",
          mainText: "У вас є збережена гра",
          buttonText: "Продовжити",
          onButtonPress: () => _goToStory(null),
        ),
        SizedBox(
          height: 20.0,
        ),
        _buildCardWithImage(
          image: "images/background/landing_0.jpg",
          mainText: "Каталог ігор",
          buttonText: "Переглянути",
          onButtonPress: () => _onViewCatalogPressed(context),
        ),
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
      String mainText,
      String buttonText,
      Function onButtonPress}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
//      padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Card(
          elevation: 0.0,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image(
                    image: AssetImage(image), fit: BoxFit.fill, height: 150.0),
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
}
