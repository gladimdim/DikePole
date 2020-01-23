import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/buildings/resource_buildings/resource_building.dart';
import 'package:locadeserta/city_building/views/components/soft_container.dart';

class ResourceBuildingImageView extends StatelessWidget {
  final RESOURCE_BUILDING_TYPES type;

  ResourceBuildingImageView({this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SoftContainer(
        child: InkWell(
          onTap: () {
//            Navigator.pushNamed(
//              context,
//              ResourceBuildingDetailsScreen.routeName,
//              arguments: ResourceBuildingDetailsScreenArguments(
//                type: type,
//              ),
//            );
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

//
//class ResourceBuildingDetailsScreenArguments {
//  final RESOURCE_BUILDING_TYPES type;
//
//  ResourceBuildingDetailsScreenArguments({this.type});
//}
//
//class ExtractResourceDetailsScreenArguments extends StatelessWidget {
//  Widget build(BuildContext context) {
//    final ResourceBuildingDetailsScreenArguments args =
//        ModalRoute
//            .of(context)
//            .settings
//            .arguments;
//
//    return ResourceBuildingDetailsScreen(
//      type: args.type,
//    );
//  }
//}
