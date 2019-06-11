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

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  bool loadingStory = false;
  final AsyncMemoizer _catalogListMemo = AsyncMemoizer();

  AnimationController gradientController;
  var gradientAnimation;
  var appearanceController;
  var appearanceAnimation;

  @override
  void initState() {
    var width = 1000.0;

    appearanceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    appearanceAnimation = Tween(begin: width, end: 0.0).animate(
      CurvedAnimation(
          parent: appearanceController, curve: Curves.linearToEaseOut),
    );
    appearanceController.forward();

    gradientController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    gradientAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: gradientController, curve: Curves.linear),
    );

    gradientController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        gradientController.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        gradientController.forward();
      }
    });

    gradientController.forward();

    super.initState();
  }

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
          return _buildStoryItem(
            image: images[index][0],
            coloredImage: images[index][1],
            mainText: story.title,
            buttonText: LDLocalizations.of(context).startStory,
            onButtonPress: () => _goToStory(story),
            context: context,
          );
        });

    return AnimatedBuilder(
      animation: appearanceAnimation,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: Offset(appearanceAnimation.value, 0.0),
          child: Container(
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildStoryItem({
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
            border: Border.all(color: Colors.black, width: 0.5),
            borderRadius: getAllRoundedBorderRadius()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0.0),
              child: ClipRRect(
                  borderRadius: getTopRoundedBorderRadius(),
                  child: TweenImage(
                    first: image,
                    last: coloredImage,
                    duration: 4,
                    repeat: true,
                  )),
            ),
            AnimatedBuilder(
              animation: gradientAnimation,
              builder: (context, widget) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: getBottomRoundedBorderRadius(),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          gradientAnimation.value,
                          1 -  gradientAnimation.value,
                        ],
                        colors: [
                          Colors.grey,
                          Colors.white,
                        ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        mainText,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                );
              },
            ),
          ],
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

  @override
  void dispose() {
    appearanceController.dispose();
    gradientController.dispose();
    super.dispose();
  }
}
