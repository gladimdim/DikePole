import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/resource_building_input_view.dart';
import 'package:sloboda/views/components/resource_building_output_view.dart';
import 'package:sloboda/views/components/soft_container.dart';

class ResourceBuildingBuiltListItemView extends StatelessWidget {
  final ResourceBuilding building;

  ResourceBuildingBuiltListItemView({this.building});

  @override
  Widget build(BuildContext context) {
    Sloboda city = InheritedCity.of(context).city;
    return BuiltBuildingListView(
      title: buildingTypeToString(building.type),
      producesIconPath: resourceTypesToIconPath(building.produces),
      amount: building.outputAmount,
      buildingIconPath: buildingTypeToIconPath(building.type),
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
        title: TitleText(buildingTypeToString(building.type)),
      ),
      body: SingleChildScrollView(
        child: SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SoftContainer(
                    child: Image.asset(
                      buildingTypeToImagePath(building.type),
                      height: 320,
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
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
                        child: Center(
                          child: TitleText(
                            'Add worker',
                          ),
                        ),
                      ),
                    ),
                  ),
                if (building.assignedHumans.isNotEmpty) ...[
                  SizedBox(
                    height: 35,
                  ),
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
                                                building.removeWorker(h);
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
                ],
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
                      child: Center(
                          child: TitleText(
                        'Destroy building',
                      )),
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