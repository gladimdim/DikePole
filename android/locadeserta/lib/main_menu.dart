import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/fade_images.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/models/Localizations.dart';
import 'package:locadeserta/models/background_image.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'animations/SlideRightNavigation.dart';
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
      appBar: AppBar(
        title: Text('Loca Deserta'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return WaitingScreen();
              break;
            case ConnectionState.done:
              if (snapshot.data.length == 0) {
                return _buildEmptyCatalogListView(context);
              } else {
                return _buildCatalogView(context, snapshot.data);
              }
              break;
          }
        },
      ),
    );
  }

  _fetchData(BuildContext context) {
    var locale = Localizations.localeOf(context);
    print('locale: ${locale.languageCode}');
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
                LDLocalizations.of(context).translationNotYetReady,
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
          return CatalogView(
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
                    }),
              );
            },
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
    Navigator.push(
      context,
      SlideRightNavigation(
        widget: StoryView(user: user, catalogStory: story),
      ),
    );
  }

  @override
  void dispose() {
    appearanceController.dispose();
    super.dispose();
  }
}
