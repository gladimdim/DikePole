import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/resource_buildings/resource_building_meta.dart';

class ResourceBuildingImageView extends StatelessWidget {
  final RESOURCE_BUILDING_TYPES type;

  ResourceBuildingImageView({this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SoftContainer(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ResourceBuildingDetailsScreen.routeName,
              arguments: ResourceBuildingDetailsScreenArguments(
                type: type,
              ),
            );
          },
          child: Image.asset(
            '${buildingTypeToIconPath(type)}',
            height: 64,
          ),
        ),
      ),
    );
  }
}

class ResourceBuildingDetailsScreen extends StatelessWidget {
  static final String routeName = '/city_building/resource_building_details';
  final RESOURCE_BUILDING_TYPES type;

  ResourceBuildingDetailsScreen({this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ResourceBuildingMetaView(
          type: type,
          selected: true,
        ),
      ),
      appBar: AppBar(
        title: TitleText(buildingTypeToString(type)),
      ),
    );
  }
}

class ResourceBuildingDetailsScreenArguments {
  final RESOURCE_BUILDING_TYPES type;

  ResourceBuildingDetailsScreenArguments({this.type});
}

class ExtractResourceBuildingDetailsScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ResourceBuildingDetailsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return ResourceBuildingDetailsScreen(
      type: args.type,
    );
  }
}
