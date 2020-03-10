import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/shooting_range.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_property.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/shooting_range_view.dart';
import 'package:sloboda/views/sich/sich_view.dart';
import 'package:sloboda/views/stock_view.dart';

class CityDashboard extends StatefulWidget {
  final Sloboda city;

  CityDashboard({this.city});

  @override
  _CityDashboardState createState() => _CityDashboardState();
}

class _CityDashboardState extends State<CityDashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideableButton(
                      child: Text(SlobodaLocalizations.trainCossacks),
                      onPress: () async {
                        await Navigator.pushNamed(
                          context,
                          ShootingRangeBuilt.routeName,
                          arguments: ShootingRangeViewArguments(
                            city: widget.city,
                            building: ShootingRange(),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            VDivider(),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FullWidth(
                  child: SlideableButton(
                    child: Center(
                      child: Text(SlobodaLocalizations.sichName),
                    ),
                    onPress: () async {
                      await Navigator.pushNamed(
                        context,
                        SichScreen.routeName,
                        arguments: SichScreenArguments(
                          city: widget.city,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            VDivider(),
            SoftContainer(
              child: StockFullView(
                stock: widget.city.stock,
                stockSimulation: widget.city.simulateStock(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(SlobodaLocalizations.resources),
                    Text(
                      widget.city.resourceBuildings.length.toString(),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleText(SlobodaLocalizations.cityBuildings),
                      Text(widget.city.cityBuildings.length.toString()),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(SlobodaLocalizations.notOccupiedCitizens),
                    Text(
                      widget.city.citizens
                          .where((citizen) => !citizen.occupied)
                          .toList()
                          .length
                          .toString(),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: CITY_PROPERTIES.values
                      .map(
                        (v) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: CityProperty(
                                  property: CityProp.fromType(v),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    HDivider(),
                                    Text(widget.city.props
                                        .getByType(v)
                                        .toString()),
                                    SaldoViewShower(
                                      value: widget.city.simulateCityProps()[v],
                                      reference: widget.city.props.getByType(v),
                                      showValue: true,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
