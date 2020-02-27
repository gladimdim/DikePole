import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_properties.dart';

class CityProperty extends StatelessWidget {
  final CITY_PROPERTIES property;

  CityProperty({this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Image.asset(
            cityPropertiesToIconPath(property),
            height: 64,
          ),
        ),
        Expanded(
          flex: 3,
          child: TitleText(
            cityPropsToLocalizedString(property),
          ),
        ),
      ],
    );
  }
}
