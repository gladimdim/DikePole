import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/views/components/buildable_requires_to_build.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityBuildingMetaView extends StatefulWidget {
  final CITY_BUILDING_TYPES type;
  final bool selected;
  final VoidCallback onBuildPressed;

  CityBuildingMetaView({this.type, this.selected = false, this.onBuildPressed});

  @override
  _CityBuildingMetaViewState createState() => _CityBuildingMetaViewState();
}

class _CityBuildingMetaViewState extends State<CityBuildingMetaView> {
  @override
  Widget build(BuildContext context) {
    var building = CityBuilding.fromType(widget.type);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SoftContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${cityBuildingTypeToString(widget.type)}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
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
              SoftContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BuildableRequiredToBuildView(
                    building: building,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              SoftContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Output'),
                      Text('${cityPropertiesToString(building.produces)}'),
                    ],
                  ),
                ),
              ),
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
                        child: Text('Build', style: Theme.of(context).textTheme.headline6,),
                      )),
                  onPress: widget.onBuildPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
