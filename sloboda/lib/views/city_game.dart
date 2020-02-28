import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_choicable_events.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_buildings/city_buildings_page.dart';
import 'package:sloboda/views/city_dashboard.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/events_view.dart';
import 'package:sloboda/views/locale_selection.dart';
import 'package:sloboda/views/resource_buildings/resource_buildings_page.dart';
import 'package:sloboda/views/stock_view.dart';

class CityGame extends StatefulWidget {
  static const routeName = "/city_game";

  @override
  _CityGameState createState() => _CityGameState();
}

typedef List<String> GenerateTitles();

class _CityGameState extends State<CityGame> {
  Sloboda city;

  GenerateTitles _pageTitles = () => [
        SlobodaLocalizations.overview,
        SlobodaLocalizations.events,
        SlobodaLocalizations.resources,
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
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: DefaultTabController(
                          length: 4,
                          child: Scaffold(
                            backgroundColor: Theme.of(context).backgroundColor,
                            appBar: AppBar(
                              bottom: TabBar(
                                tabs: [
                                  Tab(
                                    text: _pageTitles()[0],
                                  ),
                                  Tab(
                                    text: _pageTitles()[1],
                                  ),
                                  Tab(
                                    text: _pageTitles()[2],
                                  ),
                                  Tab(
                                    text: _pageTitles()[3],
                                  ),
                                ],
                              ),
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      VDivider(),
                                      LocaleSelection(
                                        locale: SlobodaLocalizations.locale,
                                        onLocaleChanged: (Locale locale) {
                                          setState(() {
                                            SlobodaLocalizations.locale =
                                                locale;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: StockFullView(
                                            stock: city.stock,
                                            stockSimulation:
                                                city.simulateStock(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: _makeTurn(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              children: <Widget>[
                                CityDashboard(city: city),
                                EventsView(
                                  events: city.events,
                                ),
                                ResourceBuildingsPage(),
                                CityBuildingsPage(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 24.0,
                        ),
                        child: SoftContainer(
                          child: FullWidth(
                            child: _makeTurn(context),
                          ),
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
    return SoftContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SlideableButton(
          direction: Direction.Left,
          child: Center(
            child: ButtonText(
              SlobodaLocalizations.makeTurn,
            ),
          ),
          onPress: () async {
            List choicableEvents = city.getChoicableRandomEvents();

            if (choicableEvents.isNotEmpty) {
              DialogAnswer result =
                  await _askForEvent(context, choicableEvents[0]);
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
        ),
      ),
    );
  }
}

enum DialogAnswer { YES, NO }
