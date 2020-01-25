import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/nature_resource.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';

class NatureResourceBuildingScreen extends StatefulWidget {
  final NaturalResource building;
  final Sloboda city;
  static final String routeName = '/city_building/nature_resource_building';

  NatureResourceBuildingScreen({this.building, this.city});

  @override
  _NatureResourceBuildingScreenState createState() =>
      _NatureResourceBuildingScreenState();
}

class _NatureResourceBuildingScreenState
    extends State<NatureResourceBuildingScreen> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    var building = widget.building;
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            building.getIconPath(),
            height: 32,
          ),
          SizedBox(
            width: 32,
          ),
          Text(
            building.toString(),
            style: Theme.of(context).textTheme.title,
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              building.getIconPath(),
              height: 512,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: !building.isEmpty()
                      ? () {
                          setState(() {
                            building.removeWorker();
                          });
                        }
                      : null,
                ),
                Row(
                  children: [
                    Text(
                      building.toString(),
                    ),
                    Text(
                        ': +${building.output()} ${resourceTypesToString(building.produces)}'),
                    if (building.hasWorkers())
                      Text('( ${building.amountOfWorkers()} '),
                    if (building.hasWorkers()) Icon(Icons.person),
                    if (building.hasWorkers()) Text(')'),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: !building.isFull()
                      ? () {
                          setState(() {
                            building.addWorker(city.getFirstFreeCitizen());
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NatureResourceBuildingArguments {
  final Sloboda city;
  final NaturalResource building;

  NatureResourceBuildingArguments({this.city, this.building});
}

class ExtractNatureResourceBuildingArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final NatureResourceBuildingArguments args =
        ModalRoute.of(context).settings.arguments;

    return NatureResourceBuildingScreen(
      city: args.city,
      building: args.building,
    );
  }
}
