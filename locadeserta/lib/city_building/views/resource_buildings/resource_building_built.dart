import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';

class ResourceBuildingBuilt extends StatefulWidget {
  final ResourceBuilding building;
  final Sloboda city;
  static final String routeName = '/city_building/resource_building';

  ResourceBuildingBuilt({this.building, this.city});

  @override
  _ResourceBuildingBuiltState createState() => _ResourceBuildingBuiltState();
}

class _ResourceBuildingBuiltState extends State<ResourceBuildingBuilt> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    var building = widget.building;
    return Scaffold(
      appBar: AppBar(
        title:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            buildingTypeToIconPath(building.type),
            height: 32,
          ),
          SizedBox(
            width: 32,
          ),
          Text(
            buildingTypeToString(building.type,),
            style: Theme.of(context).textTheme.title,
          ),

        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              buildingTypeToIconPath(building.type),
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
                      buildingTypeToString(building.type),
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
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    city.removeResourceBuilding(building);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceBuildingBuiltArguments {
  final Sloboda city;
  final ResourceBuilding building;

  ResourceBuildingBuiltArguments({this.city, this.building});
}

class ExtractResourceBuildingBuiltArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ResourceBuildingBuiltArguments args =
        ModalRoute.of(context).settings.arguments;

    return ResourceBuildingBuilt(
      city: args.city,
      building: args.building,
    );
  }
}
