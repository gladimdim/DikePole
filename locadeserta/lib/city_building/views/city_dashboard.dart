import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/components/soft_container.dart';
import 'package:locadeserta/city_building/views/stock_view.dart';

class CityDashboard extends StatefulWidget {
  final Sloboda city;

  CityDashboard({this.city});

  @override
  _CityDashboardState createState() => _CityDashboardState();
}

class _CityDashboardState extends State<CityDashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideableButton(
                  onPress: () {
                    widget.city.makeTurn();
                  },
                  child: Container(
                    height: 64,
                    child: SoftContainer(
                      child: Center(
                        child: Text('Make Turn'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: StockFullView(stock: widget.city.stock),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Resource buildings: "),
                    Text(
                      widget.city.resourceBuildings.length.toString(),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("City Buildings: "),
                      Text(widget.city.cityBuildings.length.toString()),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Free citizens: "),
                    Text(
                      widget.city.citizens
                          .where((citizen) => !citizen.occupied())
                          .toList()
                          .length
                          .toString(),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: CITY_PROPERTIES.values
                      .map(
                        (v) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              cityPropertiesToString(v),
                            ),
                            Text(
                              widget.city.properties[v].toString(),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

