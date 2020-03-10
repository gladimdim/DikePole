import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sich_connector.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class SichStatsView extends StatefulWidget {
  final Sloboda city;

  SichStatsView({@required this.city});

  @override
  _SichStatsViewState createState() => _SichStatsViewState();
}

class _SichStatsViewState extends State<SichStatsView> {
  final SichConnector sich = SichConnector();
  int _amountOfCossackToSend = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SoftContainer(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SoftContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FullWidth(
                        child: SlideableButton(
                            child: Center(
                              child: ButtonText(
                                  SlobodaLocalizations.sendCossacksToSich),
                            ),
                            onPress: () async {
                              try {
                                widget.city
                                    .removeCossacks(_amountOfCossackToSend);
                                await sich.sendCossacks(_amountOfCossackToSend);
                              } catch (e) {
                                print('Error while sending cossacks: $e');
                              }
                              setState(() {});
                            }),
                      ),
                    ),
                  ),
                ),
                VDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio<int>(
                      value: 1,
                      groupValue: _amountOfCossackToSend,
                      onChanged: (int value) {
                        setState(() {
                          _amountOfCossackToSend = value;
                        });
                      },
                    ),
                    CityPropsMiniView(
                      showLabels: false,
                      props: CityProps(
                        values: {
                          CITY_PROPERTIES.COSSACKS: 1,
                        },
                      ),
                    ),
                    Radio<int>(
                      value: 10,
                      groupValue: _amountOfCossackToSend,
                      onChanged: (int value) {
                        setState(() {
                          _amountOfCossackToSend = value;
                        });
                      },
                    ),
                    CityPropsMiniView(
                      showLabels: false,
                      props: CityProps(
                        values: {
                          CITY_PROPERTIES.COSSACKS: 10,
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        VDivider(),
        SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: sich.readStats(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Container(
                    child: Text('Failed to read data'),
                  );
                }
                var cossacks = snapshot.hasData ? snapshot.data['cossacks'] : 0;
                var gold = snapshot.hasData ? snapshot.data['gold'] : 0;
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TitleText(
                        SlobodaLocalizations.sichHas,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CityPropsMiniView(
                            props: CityProps(
                              values: {
                                CITY_PROPERTIES.COSSACKS: cossacks,
                              },
                            ),
                          ),
                          StockMiniView(
                            stock: Stock(
                              values: {
                                RESOURCE_TYPES.MONEY: gold,
                              },
                            ),
                            stockSimulation: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        VDivider(),
      ],
    );
  }
}
