import 'package:flutter/material.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityPropsMiniView extends StatelessWidget {
  final CityProps props;
  final bool showLabels;

  CityPropsMiniView({@required this.props, this.showLabels = true});

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
                InkWell(
                  child: Image.asset(
                    CityProp.fromType(key).toImagePath(),
                    width: 64,
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      CityPropScreen.routeName,
                      arguments: CityPropScreenArguments(
                        prop: CityProp.fromType(
                          key,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  '${showLabels ? CityProp.fromType(key).toLocalizedString() : ''}: ${props.getByType(key)} ',
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

class CityPropScreen extends StatefulWidget {
  static String routeName = '/city_prop_details';
  final CityProp prop;

  CityPropScreen({this.prop});

  @override
  _CityPropScreenState createState() => _CityPropScreenState();
}

class _CityPropScreenState extends State<CityPropScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.prop.toLocalizedString(),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoftContainer(
                  child: Image.asset(
                    widget.prop.toImagePath(),
                    width: 350,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SoftContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FullWidth(
                      child: Center(
                        child: Text(
                          widget.prop.toLocalizedDescriptionString(),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 18,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityPropScreenArguments {
  final CityProp prop;

  CityPropScreenArguments({this.prop});
}

class ExtractCityPropScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final CityPropScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return CityPropScreen(
      prop: args.prop,
    );
  }
}
