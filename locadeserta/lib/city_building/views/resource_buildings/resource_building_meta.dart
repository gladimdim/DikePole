import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_container.dart';

class ResourceBuildingMetaView extends StatefulWidget {
  final RESOURCE_BUILDING_TYPES type;
  final bool selected;
  VoidCallback onBuildPressed;

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${buildingTypeToString(widget.type)}',
                style: Theme
                    .of(context)
                    .textTheme
                    .title,
              ),
              SizedBox(
                height: 5,
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
          if (widget.selected) Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Build'),
              ...building.requiredToBuild.entries.map((e) {
                return Column(
                  children: [
                    Image.asset(
                      resourceTypesToImagePath(e.key),
                      height: 64,
                    ),
                    Text('${e.value}'),
                  ],
                );
              }).toList()
            ],
          ),
          if (widget.selected)SizedBox(
            height: 35,
          ),
          if (widget.selected)Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Max'),
              Row(children: [
                Text('${building.maxWorkers}x'),
                Icon(Icons.person),
              ]),
            ],
          ),
          if (widget.selected) SizedBox(
            height: 35,
          ),
          if (widget.selected) Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Outputs'),
              Text(
                  '${resourceTypesToString(building.produces)}: ${building
                      .workMultiplier}'),
            ],
          ),
          if (widget.selected) SizedBox(
            height: 35,
          ),
          if (widget.onBuildPressed != null)
            BorderedContainer(
              child: SlideableButton(
                direction: Direction.Left,
                  child:
                  FatContainer(text: 'Build'),
                  onPress:
                  widget.onBuildPressed,
              ),
            ),
        ],
      ),
    );
  }
}
