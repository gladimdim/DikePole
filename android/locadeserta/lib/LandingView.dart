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
        context, MaterialPageRoute(builder: (context) => StoryView(uid: uid, storyJson: json)));
  }

  void _onViewCatalogPressed(BuildContext context) async {
    final selectedStoryJsonString = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CatalogView()));
    _goToStory(selectedStoryJsonString);
  }

  ListView _buildLandingListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "For Privacy Policy Tap here.",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
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
        LoginView(onUserLoggedIn: (FirebaseUser user, String uid) {
          if (user != null) {
            authedUser = user;
          }
          if (uid != null) {
            userUid = uid;
          }
        }),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
          child: Card(
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image(
                      image: AssetImage("images/background/landing_1.jpg"),
                      fit: BoxFit.fill,
                      height: 200.0),
                ),
                ListTile(
                    title: Text(
                  "У вас є збережена гра",
                  style: TextStyle(fontSize: 20.0),
                )),
                ButtonTheme.bar(
                    child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () => _goToStory(null),
                        child: Text(
                          "Продовжити",
                          style: TextStyle(fontSize: 16.0),
                        ))
                  ],
                ))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0),
          child: Card(
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image(
                      image: AssetImage("images/background/landing_0.jpg"),
                      fit: BoxFit.fill,
                      height: 200.0),
                ),
                ListTile(
                    title: Text(
                  "Каталог ігор",
                  style: TextStyle(fontSize: 20.0),
                )),
                ButtonTheme.bar(
                    child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () => _onViewCatalogPressed(context),
                        child: Text(
                          "Переглянути",
                          style: TextStyle(fontSize: 16.0),
                        ))
                  ],
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
