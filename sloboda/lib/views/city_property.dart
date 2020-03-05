import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityProperty extends StatelessWidget {
  final CityProp property;

  CityProperty({this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SoftContainer(
            child: InkWell(
              child: Image.asset(
                property.toIconPath(),
                height: 64,
              ),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  CityPropScreen.routeName,
                  arguments: CityPropScreenArguments(prop: property),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TitleText(
            property.toLocalizedString(),
          ),
        ),
      ],
    );
  }
}
