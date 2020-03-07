import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/resource_buildings/resource_building_meta.dart';

class ResourceBuildingImageView extends StatelessWidget {
  final ResourceBuilding building;

  ResourceBuildingImageView({this.building});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: building.toLocalizedString(),
      child: Container(
        child: SoftContainer(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ResourceBuildingDetailsScreen.routeName,
                arguments: ResourceBuildingDetailsScreenArguments(
                  building: building,
                ),
              );
            },
            child: Image.asset(
              building.toIconPath(),
              height: 64,
            ),
          ),
        ),
      ),
    );
  }
}

class ResourceBuildingDetailsScreen extends StatelessWidget {
  static final String routeName = '/city_building/resource_building_details';
  final ResourceBuilding building;

  ResourceBuildingDetailsScreen({this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ResourceBuildingMetaView(
          building: building,
          selected: true,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: TitleText(
          building.toLocalizedString(),
        ),
      ),
    );
  }
}

class ResourceBuildingDetailsScreenArguments {
  final ResourceBuilding building;

  ResourceBuildingDetailsScreenArguments({this.building});
}

class ExtractResourceBuildingDetailsScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ResourceBuildingDetailsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return ResourceBuildingDetailsScreen(
      building: args.building,
    );
  }
}
