import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/shooting_range.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/soft_container.dart';

class ShootingRangeView extends StatelessWidget {
  final ShootingRange building;

  ShootingRangeView({this.building});

  @override
  Widget build(BuildContext context) {
    return BuiltBuildingListView(
      title: 'Shooting Range',
      buildingIconPath: building.icon,
      producesIconPath: cityPropertiesToIconPath(building.produces),
      amount: 1,
    );
  }
}

class ShootingRangeBuilt extends StatefulWidget {
  final ShootingRange building;
  final Sloboda city;
  static final String routeName = '/city_building/shooting_range';

  ShootingRangeBuilt({this.building, this.city});

  @override
  _ShootingRangeBuiltState createState() => _ShootingRangeBuiltState();
}

class _ShootingRangeBuiltState extends State<ShootingRangeBuilt> {
  @override
  Widget build(BuildContext context) {
    var building = widget.building;
    return Scaffold(
      appBar: AppBar(
        title: TitleText('Shooting range'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SoftContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SoftContainer(
                      child: Image.asset(
                        building.image,
                        height: 320,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShootingRangeViewArguments {
  final Sloboda city;
  final ShootingRange building;

  ShootingRangeViewArguments({this.city, this.building});
}

class ExtractShootingRangeBuiltArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ShootingRangeViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return ShootingRangeBuilt(
      city: args.city,
      building: args.building,
    );
  }
}
