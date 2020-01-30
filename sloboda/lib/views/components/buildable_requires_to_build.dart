import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/views/resource_view.dart';
import 'package:sloboda/extensions/list.dart';

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
        Text('Requires to build', style: Theme.of(context).textTheme.headline6,),
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