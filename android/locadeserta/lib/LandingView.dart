import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:locadeserta/LoginView.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';

class LandingView extends StatefulWidget {
  final Auth auth;
  LandingView({this.auth});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  String userUid;

  @override
  Widget build(BuildContext context) {
    return _buildLandingListView(context);
  }

  _goToStory(CatalogStory story) async {
    var user = await widget.auth.currentUser();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryView(uid: user.uid, catalogStory: story)));
  }

  _onViewCatalogPressed(BuildContext context) async {
    final selectedStory = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CatalogView()));
    _goToStory(selectedStory);
  }

  ListView _buildLandingListView(BuildContext context) {
    return ListView(
        children: <Widget>[
          LoginView(auth: widget.auth),
          _buildCardWithImage(
            image: "images/landing/landing_3.jpg",
            mainText: "У вас є збережена гра",
            buttonText: "Продовжити",
            onButtonPress: () => _goToStory(null),
            context: context
          ),
          SizedBox(
            height: 20.0,
          ),
          _buildCardWithImage(
            image: "images/landing/landing_2.jpg",
            mainText: "Каталог ігор",
            buttonText: "Переглянути",
            onButtonPress: () => _onViewCatalogPressed(context),
            context: context
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
      Function onButtonPress, @required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Card(
          elevation: 0.0,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image(
                    image: AssetImage(image), fit: BoxFit.fitHeight, height: 250.0),
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
