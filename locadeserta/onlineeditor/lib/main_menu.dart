import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onlineeditor/Localizations.dart';
import 'package:onlineeditor/StatisticsView.dart';
import 'package:onlineeditor/animations/fade_images.dart';
import 'package:onlineeditor/animations/slide_right_navigation.dart';
import 'package:onlineeditor/animations/slideable_button.dart';
import 'package:onlineeditor/catalog_view.dart';
import 'package:onlineeditor/components/app_bar_custom.dart';
import 'package:onlineeditor/components/narrow_scaffold.dart';
import 'package:onlineeditor/creator/components/fat_container.dart';
import 'package:onlineeditor/creator/components/game_view.dart';
import 'package:onlineeditor/creator/story/persistence.dart';
import 'package:onlineeditor/main_editor_view.dart';
import 'package:onlineeditor/models/background_image.dart';
import 'package:onlineeditor/models/catalogs.dart';
import 'package:onlineeditor/views/inherited_auth.dart';
import 'package:onlineeditor/waiting_screen.dart';

const LANDING_IMAGE_HEIGHT = 200.0;

class MainMenu extends StatefulWidget {
  static const String routeName = "/main_menu";

  MainMenu({story});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  bool loadingStory = false;
  final AsyncMemoizer _catalogListMemo = AsyncMemoizer();

  var appearanceController;
  var appearanceAnimation;

  @override
  void initState() {
    var width = 1000;

    appearanceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    appearanceAnimation = Tween(begin: width, end: 0.0).animate(
      CurvedAnimation(
          parent: appearanceController, curve: Curves.linearToEaseOut),
    );
    appearanceController.forward();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    List<AssetImage> allImages =
        BackgroundImage.getRandomImageForType(ImageType.LANDING)
            .getAllAvailableImages();
    allImages.forEach((AssetImage image) {
      precacheImage(image, context);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.appTitle,
      body: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1.0,
        child: FutureBuilder(
          future: _fetchData(context),
          builder: (BuildContext context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return WaitingScreen();
                break;
              case ConnectionState.done:
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return _buildEmptyCatalogListView(context);
                } else {
                  return _buildCatalogView(context, snapshot.data);
                }
                break;
            }
            return null;
          },
        ),
      ),
      actions: [
        AppBarObject(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: LDLocalizations.backToMenu,
        ),
        AppBarObject(
          text: LDLocalizations.statisticsTitle,
          onTap: () {
            Navigator.pushNamed(context, StatisticsView.routeName);
          },
        )
      ],
    );
  }

  _fetchData(BuildContext context) {
    var locale = LDLocalizations.locale;
    return _catalogListMemo.runOnce(() async {
      List<CatalogStory> catalogStories =
          await CatalogStory.getAvailableCatalogStories(locale.languageCode);
      return catalogStories;
    });
  }

  _buildEmptyCatalogListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Column(
          children: <Widget>[
            ClipRRect(
              child: Hero(
                tag: "CossackHero",
                child: TweenImage(
                  repeat: true,
                  last: AssetImage("images/background/cossack_0.jpg"),
                  first: AssetImage("images/background/c_cossack_0.jpg"),
                  duration: 4,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                LDLocalizations.translationNotYetReady,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCatalogView(BuildContext context, List<CatalogStory> stories) {
    var child = ListView.builder(
        itemCount: stories.length + 1,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: SlideableButton(
                onPress: () {
                  Navigator.pushNamed(context, MainEditorView.routeName);
                },
                child: FatContainer(
                  text: LDLocalizations.createStory,
                  backgroundColor: Colors.black87,
                ),
              ),
            );
          }
          var story = stories[index - 1];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CatalogView(
              catalogStory: story,
              onReadPressed: () => _goToStory(story, context),
              onDetailPressed: () {
                print("gogogogo");
                Navigator.pushNamed(
                  context,
                  "/story_details",
                  arguments: {
                    "expanded": true,
                    "catalogStory": story,
                    "onReadPressed": () => _goToStory(story, context),
                    "onDetailPressed": () {
                      Navigator.pop(context);
                    },
                  },
                );
              },
            ),
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

  _goToStory(CatalogStory story, context) async {
    setState(() {
      loadingStory = false;
    });

    var storyWithState;
    var user = InheritedAuth.of(context).auth.getUser();
    try {
      storyWithState =
          await StoryPersistence.instance.readyStoryStateById(user, story);
    } catch (e) {
      print(e);
    }
    Navigator.push(
      context,
      SlideRightNavigation(
        widget: InheritedAuth(
            child: GameView(
              story: storyWithState,
              catalogStory: story,
            ),
            auth: InheritedAuth.of(context).auth),
      ),
    );
  }

  @override
  void dispose() {
    appearanceController.dispose();
    super.dispose();
  }
}
