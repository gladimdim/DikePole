import 'package:flutter/material.dart';
import 'package:sloboda/models/city_properties.dart';

class CityPropsMiniView extends StatelessWidget {
  final CityProps props;

  CityPropsMiniView({@required this.props});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Row(
          children: props.getTypeKeys().map<Widget>((key) {
            return Row(
              children: <Widget>[
                Image.asset(
                  cityPropertiesToIconPath(key),
                  width: 18,
                ),
                Text(
                  '${cityPropsToLocalizedString(key)}: ${props.getByType(key)} ',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 18,
                      ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
