import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/city_buildings/city_buildings_page.dart';
import 'package:sloboda/views/city_dashboard.dart';
import 'package:sloboda/views/resource_buildings/resource_buildings_page.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class CityGame extends StatefulWidget {
  static const routeName = "/city_game";

  @override
  _CityGameState createState() => _CityGameState();
}

class _CityGameState extends State<CityGame> {
  Sloboda city;
  PageController _topPageController;
  PageController _mainPageController;
  final _pageTitles = ['Overview', 'Resource Buildings', 'City Buildings'];

  @override
  initState() {
    super.initState();

    city = Sloboda();
    city.name = 'Dimitrova';
    city.buildBuilding(
        ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.FIELD));
    city.buildBuilding(ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.MILL));

    _topPageController = PageController(initialPage: 0, viewportFraction: 1);
//    ..addListener(_onTopScroll);

    _mainPageController = PageController(initialPage: 0)
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: city.changes,
      builder: (context, snapshot) {
        return InheritedCity(
          city: city,
          child: Theme(
            data: Theme.of(context).copyWith(backgroundColor: Colors.grey[300]),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[300],
                title: StockMiniView(
                  stock: city.stock,
                  stockSimulation: city.simulateStock(),
                ),
              ),
              drawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StockFullView(
                      stock: city.stock,
                      stockSimulation: city.simulateStock(),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SoftContainer(
                        child: SlideableButton(
                          direction: Direction.Left,
                          onPress: () {
                            _goToPage(0);
                          },
                          child: Center(child: TitleText('Overview')),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SoftContainer(
                        child: SlideableButton(
                          direction: Direction.Left,
                          onPress: () {
                            _goToPage(1);
                          },
                          child: Center(child: TitleText('Resource Buildings')),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SoftContainer(
                        child: SlideableButton(
                          direction: Direction.Left,
                          onPress: () {
                            _goToPage(2);
                          },
                          child: Center(child: TitleText('City Buildings')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _topPageController,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: SoftContainer(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  if (index != 0)
                                    SoftContainer(
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          _goToPage(index - 1);
                                        },
                                      ),
                                    ),
                                  if (index == 0) SizedBox(width: 50),
                                  TitleText(
                                    _pageTitles[index],
                                  ),
                                  if (index != _pageTitles.length - 1)
                                    SoftContainer(
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          _goToPage(index + 1);
                                        },
                                      ),
                                    ),
                                  if (index == _pageTitles.length - 1)
                                    SizedBox(width: 50),
                                ],
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
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        if (index == 1) {
                          return ResourceBuildingsPage();
                        } else if (index == 0) {
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
            ),
          ),
        );
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
