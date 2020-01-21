import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';

class ResourceDetailsView extends StatelessWidget {
  final RESOURCE_TYPES type;

  ResourceDetailsView({this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          resourceTypesToString(type),
        ),
        Text('Some description'),
      ],
    );
  }
}

class ResourceImageView extends StatelessWidget {
  final RESOURCE_TYPES type;

  ResourceImageView({this.type});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

