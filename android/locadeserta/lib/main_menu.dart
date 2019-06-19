import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/catalog_view.dart';
import 'package:locadeserta/story_view.dart';
import 'package:locadeserta/models/Auth.dart';
import 'package:locadeserta/models/catalogs.dart';
import 'package:locadeserta/waiting_screen.dart';
import 'animations/SlideRightNavigation.dart';
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
