import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/buildings/city_buildings/city_building.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/city_building/views/city_buildings/city_building_meta.dart';

class CityBuildingsPage extends StatefulWidget {
  final Sloboda city;

  CityBuildingsPage({this.city});

  @override
  _CityBuildingsPageState createState() => _CityBuildingsPageState();
}

class _CityBuildingsPageState extends State<CityBuildingsPage> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: CITY_BUILDING_TYPES.values.map((v) => CityBuildingMetaView(type: v,)).toList(),
      ),
    );
  }
}
