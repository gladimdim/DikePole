import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/views/city_buildings/city_building_meta.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityBuildingImageView extends StatelessWidget {
  final CITY_BUILDING_TYPES type;

  CityBuildingImageView({this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SoftContainer(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              CityBuildingDetailsScreen.routeName,
              arguments: CityBuildingDetailsScreenArguments(
                type: type,
              ),
            );
          },
          child: Image.asset(
            '${cityTypeToIconPath(type)}',
            height: 64,
          ),
        ),
      ),
    );
  }
}

class CityBuildingDetailsScreen extends StatelessWidget {
  static final String routeName = '/city_building/city_building_details';
  final CITY_BUILDING_TYPES type;

  CityBuildingDetailsScreen({this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText(
          localizedCityBuildingByType(type),
        ),
      ),
      body: SingleChildScrollView(
        child: CityBuildingMetaView(
          type: type,
          selected: true,
        ),
      ),
    );
  }
}

class CityBuildingDetailsScreenArguments {
  final CITY_BUILDING_TYPES type;

  CityBuildingDetailsScreenArguments({this.type});
}

class ExtractCityBuildingDetailsScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final CityBuildingDetailsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return CityBuildingDetailsScreen(
      type: args.type,
    );
  }
}
