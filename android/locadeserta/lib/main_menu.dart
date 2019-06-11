import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/radiuses.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/models/BackgroundImage.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'animations/SlideRightNavigation.dart';
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

class _MainMenuState extends State<MainMenu>
    with TickerProviderStateMixin {
  bool loadingStory = false;
  final AsyncMemoizer _catalogListMemo = AsyncMemoizer();

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

  _fetchData() {
    return _catalogListMemo.runOnce(() async {
      List<CatalogStory> catalogStories =
          await Persistence.instance.getAvailableCatalogStories();
      return catalogStories;
    });
  }

  Widget _buildLandingListView(BuildContext context) {
    return FutureBuilder(
      future: _fetchData(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return WaitingScreen();
            break;
          case ConnectionState.done:
            return _buildCatalogView(context, snapshot.data);
            break;
        }
      },
    );
  }

  _buildCatalogView(BuildContext context, List<CatalogStory> stories) {
    var width = MediaQuery.of(context).size.width;
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

    var child = ListView.builder(
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

    var controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    var animation = Tween(begin: width, end: 0.0).animate(CurvedAnimation(
        parent: controller, curve: Curves.linear));
    controller.forward();
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: Offset(animation.value, 0.0),
          child: Container(
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildCardWithImage({
    AssetImage image,
    AssetImage coloredImage,
    String mainText,
    String buttonText,
    Function onButtonPress,
    @required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: getTopRoundedBorderRadius()),
        child: Card(
          elevation: 0.0,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: getTopRoundedBorderRadius(),
                  child: TweenImage(
                    first: image,
                    last: coloredImage,
                    duration: 4,
                    repeat: true,
                  )),
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

  _goToStory(CatalogStory story) async {
    var user = await widget.auth.currentUser();
    setState(() {
      loadingStory = false;
    });
    Navigator.push(
        context,
        SlideRightNavigation(
            widget: StoryView(user: user, catalogStory: story)));
  }
}
