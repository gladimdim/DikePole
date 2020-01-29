import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/models/buildings/resource_buildings/nature_resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/components/resource_building_output_view.dart';
import 'package:sloboda/views/components/soft_container.dart';

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
            style: Theme.of(context).textTheme.headline6,
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
                    building.getIconPath(),
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
              ],
            ),
          ),
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
