import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/locale_selection.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/city_buildings/city_buildings_page.dart';
import 'package:sloboda/views/city_dashboard.dart';
import 'package:sloboda/views/components/arrow_right.dart';
import 'package:sloboda/views/events_view.dart';
import 'package:sloboda/views/resource_buildings/resource_buildings_page.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class CityGame extends StatefulWidget {
  static const routeName = "/city_game";

  @override
  _CityGameState createState() => _CityGameState();
}

typedef List<String> GenerateTitles();

class _CityGameState extends State<CityGame> {
  Sloboda city;
  PageController _topPageController;
  PageController _mainPageController;
  GenerateTitles _pageTitles = () => [
        SlobodaLocalizations.events,
        SlobodaLocalizations.overview,
        SlobodaLocalizations.resourceBuildings,
        SlobodaLocalizations.cityBuildings,
      ];

  final AsyncMemoizer _appPreferencesInitter = AsyncMemoizer();

  @override
  initState() {
    super.initState();

    if (kReleaseMode) {
      city = Sloboda();
    } else {
      city = Sloboda(stock: Stock.bigStock(), props: CityProps.bigProps());
    }
    city.name = 'Dimitrova';
    city.buildBuilding(
        ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.FIELD));
    city.buildBuilding(ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.MILL));

    _topPageController = PageController(initialPage: 1, viewportFraction: 1);

    _mainPageController = PageController(initialPage: 1)
      ..addListener(_onMainScroll);
  }

  _onMainScroll() {
    _topPageController.animateTo(_mainPageController.offset,
        duration: Duration(milliseconds: 150), curve: Curves.decelerate);
  }

  _goToPage(int page) {
    _topPageController.animateToPage(page,
        duration: Duration(milliseconds: 150), curve: Curves.decelerate);
    _mainPageController.animateToPage(page,
        duration: Duration(milliseconds: 40), curve: Curves.decelerate);
  }

  _appPreferencesInit() {
    return _appPreferencesInitter.runOnce(() => AppPreferences.instance.init());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: city.changes,
      builder: (context, snapshot) {
        return InheritedCity(
          city: city,
          child: FutureBuilder(
            future: _appPreferencesInit(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    title: StockMiniView(
                      stock: city.stock,
                      stockSimulation: city.simulateStock(),
                    ),
                  ),
                  drawer: Drawer(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Theme.of(context).backgroundColor,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            VDivider(),
                            LocaleSelection(
                              locale: SlobodaLocalizations.locale,
                              onLocaleChanged: (Locale locale) {
                                setState(() {
                                  SlobodaLocalizations.locale = locale;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SoftContainer(
                                child: StockFullView(
                                  stock: city.stock,
                                  stockSimulation: city.simulateStock(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SoftContainer(
                                child: _makeTurn(context),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SoftContainer(
                                child: SlideableButton(
                                  direction: Direction.Left,
                                  onPress: () {
                                    _goToPage(1);
                                  },
                                  child: Center(
                                      child: ButtonText(_pageTitles()[1])),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SoftContainer(
                                child: SlideableButton(
                                  direction: Direction.Left,
                                  onPress: () {
                                    _goToPage(2);
                                  },
                                  child: Center(
                                      child: ButtonText(_pageTitles()[2])),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SoftContainer(
                                child: SlideableButton(
                                  direction: Direction.Left,
                                  onPress: () {
                                    _goToPage(3);
                                  },
                                  child: Center(
                                      child: ButtonText(_pageTitles()[3])),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _topPageController,
                          itemCount: _pageTitles().length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 64,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SoftContainer(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          if (index != 0)
                                            Expanded(
                                              flex: 1,
                                              child: SoftContainer(
                                                child: IconButton(
                                                  icon: ArrowLeft(),
                                                  onPressed: () {
                                                    _goToPage(index - 1);
                                                  },
                                                ),
                                              ),
                                            ),
                                          HDivider(),
                                          Expanded(
                                            flex: 4,
                                            child: TitleText(
                                              index == 1
                                                  ? '${SlobodaLocalizations.getForKey(city.currentSeason.toLocalizedKey())} ${city.currentYear}'
                                                  : _pageTitles()[index],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: SoftContainer(
                                              child: _makeTurn(context),
                                            ),
                                          ),
                                          HDivider(),
                                          if (index != _pageTitles().length - 1)
                                            Expanded(
                                              flex: 1,
                                              child: SoftContainer(
                                                child: IconButton(
                                                  icon: ArrowRight(),
                                                  onPressed: () {
                                                    _goToPage(index + 1);
                                                  },
                                                ),
                                              ),
                                            ),
                                          if (index == _pageTitles().length - 1)
                                            HDivider(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: PageView.builder(
                          controller: _mainPageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _pageTitles().length,
                          itemBuilder: (context, index) {
                            if (index == 2) {
                              return ResourceBuildingsPage();
                            } else if (index == 0) {
                              return EventsView(
                                events: city.events,
                              );
                            } else if (index == 1) {
                              return CityDashboard(
                                city: city,
                              );
                            } else {
                              return CityBuildingsPage();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  Future<DialogAnswer> _askForEvent(
      BuildContext context, ChoicableRandomTurnEvent event) async {
    DialogAnswer result = await showDialog<DialogAnswer>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              SlobodaLocalizations.getForKey(event.localizedQuestionKey),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, DialogAnswer.YES),
                child: Text(SlobodaLocalizations.yesToRandomEvent),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, DialogAnswer.NO),
                child: Text(SlobodaLocalizations.noToRandomEvent),
              ),
            ],
          );
        });

    return result;
  }

  Widget _makeTurn(BuildContext context) {
    return SlideableButton(
      direction: Direction.Left,
      child: Center(
        child: ButtonText(
          SlobodaLocalizations.makeTurn,
        ),
      ),
      onPress: () async {
        List choicableEvents = city.getChoicableRandomEvents();

        if (choicableEvents.isNotEmpty) {
          DialogAnswer result = await _askForEvent(context, choicableEvents[0]);
          city.addChoicableEventWithAnswer(
              result == DialogAnswer.YES, choicableEvents[0]);
          city.makeTurn();
          if (result == DialogAnswer.YES) {
            city.runChoicableEventResult(choicableEvents[0]);
          }
        } else {
          city.makeTurn();
        }
      },
    );
  }

  @override
  void dispose() {
    _topPageController.dispose();
    _mainPageController.dispose();
    super.dispose();
  }
}

enum DialogAnswer { YES, NO }
