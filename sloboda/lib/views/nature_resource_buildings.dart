import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/resource_buildings/nature_resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
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
        backgroundColor: Theme.of(context).backgroundColor,
        title: TitleText(building.toLocalizedString()),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        building.getIconPath(),
                        height: 320,
                      ),
                    ),
                  ),
                ),
                if (!building.isFull()) ...[
                  SizedBox(
                    height: 35,
                  ),
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
                          child: TitleText(SlobodaLocalizations.addWorker),
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: 32,
                ),
                if (building.assignedHumans.isNotEmpty)
                  SoftContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Center(child: Text(SlobodaLocalizations.assignedWorkers)),
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
