import 'package:flutter/material.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/inherited_city.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/components/resource_building_input_view.dart';
import 'package:locadeserta/city_building/views/components/resource_building_output_view.dart';
import 'package:locadeserta/city_building/views/components/soft_container.dart';

class ResourceBuildingBuiltListItemView extends StatelessWidget {
  final ResourceBuilding building;

  ResourceBuildingBuiltListItemView({this.building});

  @override
  Widget build(BuildContext context) {
    Sloboda city = InheritedCity.of(context).city;
    return SoftContainer(
      child: SlideableButton(
        child: Container(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  buildingTypeToIconPath(building.type),
                ),
                Text(
                  buildingTypeToString(building.type),
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      resourceTypesToImagePath(building.produces),
                      height: 32,
                    ),
                    Text(
                      'x ${building.outputAmount}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ],
            ),
          ),
        ),
        onPress: () {
          Navigator.pushNamed(
            context,
            ResourceBuildingBuilt.routeName,
            arguments: ResourceBuildingBuiltArguments(
              city: city,
              building: building,
            ),
          );
        },
      ),
    );
  }
}

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
          title: Row(
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
            buildingTypeToString(
              building.type,
            ),
            style: Theme.of(context).textTheme.title,
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    buildingTypeToIconPath(building.type),
                    height: 320,
                  ),
                ),
                if (!building.isFull())
                  SoftContainer(
                    child: SlideableButton(
                      onPress: !building.isFull()
                          ? () {
                              setState(() {
                                building.addWorker(city.getFirstFreeCitizen());
                              });
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('Add worker')),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 32,
                ),
                if (building.assignedHumans.isNotEmpty)
                  SoftContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Center(child: Text('Assigned workers')),
                        ...building.assignedHumans.map(
                          (h) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    h.name,
                                  ),
                                  SoftContainer(
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: !building.isEmpty()
                                          ? () {
                                              setState(() {
                                                building.removeWorker();
                                              });
                                            }
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ]),
                    ),
                  ),
                SizedBox(
                  height: 32,
                ),
                if (building.requires.isNotEmpty && building.hasWorkers()) ...[
                  SoftContainer(
                    child: ResourceBuildingInputView(
                      building: building,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
                if (building.assignedHumans.isNotEmpty) ...[
                  SoftContainer(
                    child: ResourceBuildingOutputView(
                      building: building,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
                SizedBox(
                  height: 64,
                  child: SoftContainer(
                    child: SlideableButton(
                      child: Center(child: Text('Destroy building')),
                      onPress: () {
                        city.removeResourceBuilding(building);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
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
