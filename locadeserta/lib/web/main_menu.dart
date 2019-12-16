import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/web/StatisticsView.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slide_right_navigation.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/components/transforming_page_view.dart';
import 'package:locadeserta/web/creator/components/fat_container.dart';
import 'package:locadeserta/web/creator/components/game_view.dart';
import 'package:locadeserta/web/creator/story/persistence.dart';
import 'package:locadeserta/web/main_editor_view.dart';
import 'package:locadeserta/web/models/background_image.dart';
import 'package:locadeserta/web/models/catalogs.dart';
import 'package:locadeserta/web/views/inherited_auth.dart';
import 'package:locadeserta/web/waiting_screen.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';

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
  List<CatalogStory> stories;
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
                stories = List.from(snapshot.data);
                stories.sort(
                    (story1, story2) => story1.year.compareTo(story2.year));
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
      return catalogStories
          .where((story) => story.title != "Після Битви")
          .toList();
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
                  repeat: false,
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
    var child = TransformingPageView(
        titles:
            stories.map((story) => "${story.year}: ${story.title}").toList(),
        scrollDirection: Axis.vertical,
        onStorySelected: (index) => _goToStory(stories[index], context),
        onDetailsSelected: (story) {
          Navigator.pushNamed(
            context,
            "/story_details",
            arguments: {
              "expanded": true,
              "catalogStory": story,
              "onReadPressed": (index) => _goToStory(stories[index], context),
              "onDetailPressed": () {
                Navigator.pop(context);
              },
            },
          );
        });

    return AnimatedBuilder(
      animation: appearanceAnimation,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: Offset(appearanceAnimation.value, 0.0),
          child: Column(
            children: [
              Padding(
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
              ),
              Expanded(flex: 1, child: child),
            ],
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
          auth: InheritedAuth.of(context).auth,
        ),
      ),
    );
  }

  @override
  void dispose() {
    appearanceController.dispose();
    super.dispose();
  }
}
