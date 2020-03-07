import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/buildable_requires_to_build.dart';
import 'package:sloboda/views/components/resource_building_input_view.dart';
import 'package:sloboda/views/components/resource_building_output_view.dart';
import 'package:sloboda/views/components/soft_container.dart';

class ResourceBuildingMetaView extends StatefulWidget {
  final ResourceBuilding building;
  final bool selected;
  final VoidCallback onBuildPressed;

  ResourceBuildingMetaView(
      {this.building, this.selected = false, this.onBuildPressed});

  @override
  _ResourceBuildingMetaViewState createState() =>
      _ResourceBuildingMetaViewState();
}

class _ResourceBuildingMetaViewState extends State<ResourceBuildingMetaView> {
  @override
  Widget build(BuildContext context) {
    var building = widget.building;
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
                    TitleText(
                      building.toLocalizedString(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        building.toImagePath(),
                        height: widget.selected ? 256 : 128,
                      ),
                    ),
                  ],
                ),
                if (widget.selected)
                  SoftContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(building.toLocalizedDescriptionString()),
                    ),
                  ),
                if (widget.selected)
                  SizedBox(
                    height: 35,
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
                        Text(SlobodaLocalizations.maxNumberOfWorkers),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Citizen.getIconPath()),
                            Text(' ${building.maxWorkers}'),
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
                  SoftContainer(
                      child: ResourceBuildingOutputView(building: building)),
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
                          child: ButtonText(
                            SlobodaLocalizations.build,
                          ),
                        ),
                      ),
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
