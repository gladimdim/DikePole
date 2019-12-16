import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/InheritedAuth.dart';
import 'package:locadeserta/StatisticsView.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/components/transforming_page_view.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/components/game_view.dart';
import 'package:locadeserta/creator/components/user_stories_list_view.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'package:locadeserta/animations/slide_right_navigation.dart';
import 'package:locadeserta/models/persistence.dart';
import 'package:locadeserta/creator/story/persistence.dart'
    as GladStoryPersistence;
import 'package:locadeserta/radiuses.dart';

const LANDING_IMAGE_HEIGHT = 200.0;

class MainMenu extends StatefulWidget {
  static String routeName = "/main_menu";
  MainMenu({story});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  bool loadingStory = false;
  final AsyncMemoizer _catalogListMemo = AsyncMemoizer();
  var appearanceController;
  var appearanceAnimation;

  List<CatalogStory> stories;

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
    debugPrint("kuku");
    var locale = LDLocalizations.locale;
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
      titles: stories.map((story) => "${story.year}: ${story.title}").toList(),
      scrollDirection: Axis.vertical,
      onStorySelected: (index) => _goToStory(stories[index], context),
      onDetailsSelected: (index) => Navigator.pushNamed(
        context,
        ExtractCatalogViewArguments.routeName,
        arguments: CatalogViewArguments(
          expanded: true,
          catalogStory: stories[index],
          onReadPressed: () => _goToStory(stories[index], context),
          onDetailPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

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
                    Navigator.pushNamed(context, UserStoriesList.routeName);
                  },
                  child: BorderedContainer(
                    child: FatContainer(
                      text: LDLocalizations.createStory,
                    ),
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
    var user = await InheritedAuth.of(context).auth.currentUser();
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
      var storyWithState;
      try {
        storyWithState = await GladStoryPersistence.StoryPersistence.instance
            .readyStoryStateById(user, story);
      } catch (e) {
        print(e);
      }

      Navigator.push(
        context,
        SlideRightNavigation(
          widget: GameView(
            story: storyWithState,
            catalogStory: story,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    appearanceController.dispose();
    super.dispose();
  }
}
