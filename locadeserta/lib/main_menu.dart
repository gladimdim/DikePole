import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/constants.dart';
import 'package:locadeserta/creator/components/fat_button.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/story/story.dart' as GladStory;
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'package:locadeserta/animations/slide_right_navigation.dart';
import 'package:locadeserta/models/persistence.dart';
import 'package:locadeserta/radiuses.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: APP_BAR_HEIGHT * 1.2, left: 4.0, right: 4.0),
              child: SlideableButton(
                onPress: () {
                  Navigator.pushNamed(context, "/create");
                },
                child: FatButton(
                  text: LDLocalizations
                      .of(context)
                      .createStory,
                  backgroundColor: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: APP_BAR_HEIGHT * 3),
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
            AppBarCustom(
              title: LDLocalizations
                  .of(context)
                  .appTitle,
              appBarButtons: [
                AppBarObject(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  text: LDLocalizations
                      .of(context)
                      .backToMenu,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _fetchData(BuildContext context) {
    var locale = Localizations.localeOf(context);
    return _catalogListMemo.runOnce(() async {
      List<CatalogStory> catalogStories = await Persistence.instance
          .getAvailableCatalogStories(locale.languageCode);
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
              borderRadius: getAllRoundedBorderRadius(),
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
                LDLocalizations
                    .of(context)
                    .translationNotYetReady,
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
        itemCount: stories.length,
        itemBuilder: (BuildContext context, int index) {
          var story = stories[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 48.0),
            child: CatalogView(
              catalogStory: story,
              onReadPressed: () => _goToStory(story),
              onDetailPressed: () {
                Navigator.pushNamed(
                  context,
                  "/story_details",
                  arguments: CatalogViewArguments(
                    expanded: true,
                    catalogStory: story,
                    onReadPressed: () => _goToStory(story),
                    onDetailPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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

  _goToStory(CatalogStory story) async {
    var user = await widget.auth.currentUser();
    setState(() {
      loadingStory = false;
    });
    if (story.inkJson != null) {
      Navigator.push(
        context,
        SlideRightNavigation(
          widget: StoryView(
            user: user,
            catalogStory: story,
          ),
        ),
      );
    } else {
      Navigator.push(
          context,
          SlideRightNavigation(
              widget: GameView(
                locale: Localizations.localeOf(context),
                story: GladStory.Story.fromJson(story.gladJson),
              )));
    }
  }

  @override
  void dispose() {
    appearanceController.dispose();
    super.dispose();
  }
}
