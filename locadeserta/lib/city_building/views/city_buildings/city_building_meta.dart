import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/creator/components/fat_container.dart';

class CityBuildingMetaView extends StatefulWidget {
  final CITY_BUILDING_TYPES type;
  final bool selected;
  final VoidCallback onBuildPressed;

  CityBuildingMetaView(
      {this.type, this.selected = false, this.onBuildPressed});

  @override
  _CityBuildingMetaViewState createState() =>
      _CityBuildingMetaViewState();
}

class _CityBuildingMetaViewState extends State<CityBuildingMetaView> {
  @override
  Widget build(BuildContext context) {
    var building = CityBuilding.fromType(widget.type);
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
                '${cityBuildingTypeToString(widget.type)}',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .merge(TextStyle(fontSize: widget.selected ? 25 : 30)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  cityTypeToIconPath(widget.type),
                  height: 320,
                ),
              ),
            ],
          ),
          if (widget.selected) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Requires to build'),
                Column(
                    children: building.requiredToBuild.entries.map((e) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            resourceTypesToImagePath(e.key),
                            height: 64,
                          ),
                          Text(': ${e.value}'),
                        ],
                      );
                    }).toList())
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Output'),
                Text(
                    '${cityPropertiesToString(building.produces)}'),
              ],
            ),
            SizedBox(
              height: 35,
            ),
          ],
          if (widget.onBuildPressed != null)
            BorderedContainer(
              child: SlideableButton(
                direction: Direction.Left,
                child: FatContainer(text: 'Build'),
                onPress: widget.onBuildPressed,
              ),
            ),
        ],
      ),
    );
  }
}
