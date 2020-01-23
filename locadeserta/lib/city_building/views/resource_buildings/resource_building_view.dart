import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/views/components/soft_container.dart';
import 'package:locadeserta/city_building/views/resource_buildings/resource_building_meta.dart';
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';

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
    return NarrowScaffold(
      body: SingleChildScrollView(
        child: ResourceBuildingMetaView(
          type: type,
          selected: true,
        ),
      ),
      title: buildingTypeToString(type),
      actions: [
        AppBarObject(
            text: 'Back',
            onTap: () {
              Navigator.pop(context);
            })
      ],
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
