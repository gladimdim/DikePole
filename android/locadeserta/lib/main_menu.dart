import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/models/BackgroundImage.dart';
import 'animations/TweenImage.dart';
import 'models/Localizations.dart';
import 'package:locadeserta/models/persistence.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Loca Deserta'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildLandingListView(context),
    );
  }

  Widget _buildLandingListView(BuildContext context) {
    return FutureBuilder<List<CatalogStory>>(
      future: Persistence.instance.getAvailableCatalogStories(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: Hero(
                tag: "CossackHero",
                child: TweenImage(
                  last: AssetImage("images/background/cossack_0.jpg"),
                  first: AssetImage("images/background/c_cossack_0.jpg"),
                  height: 300,
                ),
              ),
            );
            break;
          case ConnectionState.done:
            return _buildCatalogView(context, snapshot.data);
            break;
        }
      },
    );
  }

  _buildCatalogView(BuildContext context, List<CatalogStory> stories) {
    var images = [
      [
        BackgroundImage.getAssetImageForType(ImageType.LANDING),
        BackgroundImage.getColoredAssetImageForType(ImageType.LANDING),
      ],
    ];

    BackgroundImage.nextRandomForType(ImageType.LANDING);

    images.add(
      [
        BackgroundImage.getAssetImageForType(ImageType.LANDING),
        BackgroundImage.getColoredAssetImageForType(ImageType.LANDING),
      ],
    );

    return ListView.builder(
        itemCount: stories.length,
        itemBuilder: (BuildContext context, int index) {
          var story = stories[index];
          return _buildCardWithImage(
            image: images[index][0],
            coloredImage: images[index][1],
            mainText: story.title,
            buttonText: LDLocalizations.of(context).startStory,
            onButtonPress: () => _goToStory(story),
            context: context,
          );
        });
  }

  Widget _buildCardWithImage(
      {AssetImage image,
      AssetImage coloredImage,
      String mainText,
      String buttonText,
      Function onButtonPress,
      @required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
                    first: image,
                    last: coloredImage,
                    duration: 2,
                    repeat: true,
                  ),
                ),
              ),
              ListTile(
                  title: Text(
                mainText,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    if (loadingStory)
                      Text(
                        LDLocalizations.of(context).loadingStory,
                      ),
                    if (!loadingStory)
                      FlatButton(
                        onPressed: onButtonPress,
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
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

  _goToStory(CatalogStory story) async {
    var user = await widget.auth.currentUser();
    setState(() {
      loadingStory = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryView(user: user, catalogStory: story)));
  }
}
