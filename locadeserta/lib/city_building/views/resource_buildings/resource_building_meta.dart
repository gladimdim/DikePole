import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/views/components/resource_building_input_view.dart';
import 'package:locadeserta/city_building/views/components/resource_building_output_view.dart';
import 'package:locadeserta/city_building/views/components/buildable_requires_to_build.dart';
import 'package:locadeserta/city_building/views/components/soft_container.dart';

class ResourceBuildingMetaView extends StatefulWidget {
  final RESOURCE_BUILDING_TYPES type;
  final bool selected;
  final VoidCallback onBuildPressed;

  ResourceBuildingMetaView(
      {this.type, this.selected = false, this.onBuildPressed});

  @override
  _ResourceBuildingMetaViewState createState() =>
      _ResourceBuildingMetaViewState();
}

class _ResourceBuildingMetaViewState extends State<ResourceBuildingMetaView> {
  @override
  Widget build(BuildContext context) {
    var building = ResourceBuilding.fromType(widget.type);
    return SoftContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SoftContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${buildingTypeToString(widget.type)}',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 30)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      buildingTypeToIconPath(widget.type),
                      height: 320,
                    ),
                  ),
                ],
              ),
              if (widget.selected) ...[
                SoftContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BuildableRequiredToBuildView(building: building),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                SoftContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Max number of workers'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${building.maxWorkers}x'),
                          Icon(Icons.person),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                if (building.requires.isNotEmpty)
                  SoftContainer(
                    child: ResourceBuildingInputView(building: building),
                  ),
                SizedBox(
                  height: 35,
                ),
                ResourceBuildingOutputView(building: building),
                SizedBox(
                  height: 35,
                ),
              ],
              if (widget.onBuildPressed != null)
                SoftContainer(
                  child: SlideableButton(
                    direction: Direction.Left,
                    child: Container(
                      height: 64,
                      child: Center(
                        child: Text('Build'),
                      ),
                    ),
                    onPress: widget.onBuildPressed,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


