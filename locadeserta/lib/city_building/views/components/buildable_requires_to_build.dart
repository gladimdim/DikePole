import 'package:flutter/widgets.dart';
import 'package:locadeserta/city_building/models/abstract/buildable.dart';
import 'package:locadeserta/city_building/views/resource_view.dart';
import 'package:locadeserta/extensions/list.dart';

class BuildableRequiredToBuildView extends StatelessWidget {
  const BuildableRequiredToBuildView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final Buildable building;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Requires to build'),
        Column(
          children: building.requiredToBuild.entries
              .toList()
              .divideBy(2)
              .map(
                (row) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row
                      .map((e) => Row(
                            children: <Widget>[
                              ResourceImageView(
                                type: e.key,
                              ),
                              Text('x ${e.value}'),
                            ],
                          ))
                      .toList(),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
