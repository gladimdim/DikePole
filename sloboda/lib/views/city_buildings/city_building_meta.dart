import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
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
    return SoftContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${localizedCityBuildingByType(widget.type)}',
                      style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(fontSize: widget.selected ? 30 : 25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        cityTypeToImagePath(widget.type),
                        height: widget.selected ? 256 : 128,
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
                          Text(SlobodaLocalizations.output),
                          Image.asset(
                            Citizen.getIconPath(),
                          ),
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
                            child: ButtonText(SlobodaLocalizations.build),
                          )),
                      onPress: widget.onBuildPressed,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
