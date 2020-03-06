import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/resource_view.dart';

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
        Text(SlobodaLocalizations.requiredToBuildBy),
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
                                type: ResourceType.fromType(e.key),
                              ),
                              Text(' ${e.value}'),
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
