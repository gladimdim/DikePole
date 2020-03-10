import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/shooting_range.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/built_building_listview.dart';

class ShootingRangeView extends StatelessWidget {
  final ShootingRange building;

  ShootingRangeView({this.building});

  @override
  Widget build(BuildContext context) {
    return BuiltBuildingListView(
      title: SlobodaLocalizations.getForKey(building.localizedKey),
      buildingIconPath: building.icon,
      producesIconPath: building.produces.toIconPath(),
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
        title: TitleText(
          SlobodaLocalizations.getForKey(building.localizedKey),
        ),
      ),
      body: StreamBuilder(
          stream: widget.city.changes,
          builder: (context, snapshot) {
            return building.build(context, () {
              setState(() {});
            }, widget.city);
          }),
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
