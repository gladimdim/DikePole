import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/city_buildings/city_buildings_page.dart';
import 'package:sloboda/views/city_dashboard.dart';
import 'package:sloboda/views/resource_buildings/resource_buildings_page.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';
import 'package:sloboda/components/app_bar_custom.dart';
import 'package:sloboda/components/narrow_scaffold.dart';

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
    city.resourceBuildings
        .add(ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.FIELD));
    city.resourceBuildings
        .add(ResourceBuilding.fromType(RESOURCE_BUILDING_TYPES.MILL));

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
            child: NarrowScaffold(
              titleView: StockMiniView(
                stock: city.stock,
                stockSimulation: city.simulateStock(),
              ),
              actions: [
                AppBarObject(
                    text: 'Change Lang',
                    onTap: () {
                      // Navigator.pop(context);
                    })
              ],
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _topPageController,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 22.0, right: 22.0, bottom: 16),
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
                                  Text(_pageTitles[index]),
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
