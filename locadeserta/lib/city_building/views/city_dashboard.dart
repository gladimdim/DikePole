import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/sloboda.dart';
import 'package:locadeserta/components/bordered_container.dart';

class CityDashboard extends StatefulWidget {
  final Sloboda city;

  CityDashboard({this.city});

  @override
  _CityDashboardState createState() => _CityDashboardState();
}

class _CityDashboardState extends State<CityDashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        BorderedContainer(
          child: Row(
            children: [
              Text("Name: "),
              Text(widget.city.name),
            ],
          ),
        ),
        BorderedContainer(
          child: Row(
            children: [
              Text("Resource buildings: "),
              Text(
                widget.city.resourceBuildings.length.toString(),
              )
            ],
          ),
        ),
        BorderedContainer(
          child: Row(children: [
            Text("City Buildings: "),
            Text(widget.city.cityBuildings.length.toString()),
          ]),
        ),
        BorderedContainer(
          child: Row(
            children: <Widget>[
              Text("Citizens: "),
              Text(widget.city.citizens.length.toString()),
            ],
          ),
        ),
        BorderedContainer(
          child: Row(
            children: [
              Text("Not occupied citizens: "),
              Text(widget.city.citizens.where((citizen) => !citizen.occupied()).toList().length.toString(),)
            ],
          ),
        ),
      ],
    );
  }
}
