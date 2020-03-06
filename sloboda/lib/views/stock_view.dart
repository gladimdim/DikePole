import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/components/lined_container.dart';
import 'package:sloboda/views/resource_view.dart';

class StockMiniView extends StatelessWidget {
  final Stock stock;
  final Map<RESOURCE_TYPES, int> stockSimulation;

  StockMiniView({@required this.stock, @required this.stockSimulation});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Row(
          children: stock.getTypeKeys().map<Widget>((key) {
            return Row(
              children: <Widget>[
                Image.asset(
                  ResourceType.fromType(key).toIconPath(),
                  width: 18,
                ),
                Text(
                  '${ResourceType.fromType(key).toLocalizedString()}: ${stock.getByType(key)} ',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 18,
                      ),
                ),
                if (stockSimulation != null)
                  SaldoViewShower(
                    value: stockSimulation[key],
                    reference: stock.getByType(key),
                    showValue: false,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StockFullView extends StatelessWidget {
  final Stock stock;
  final Map<RESOURCE_TYPES, int> stockSimulation;

  StockFullView({
    @required this.stock,
    this.stockSimulation = null,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TitleText(
              SlobodaLocalizations.stock,
            ),
            ...RESOURCE_TYPES.values.divideBy(2).map<Widget>(
              (List keys) {
                return LineContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: keys
                        .map(
                          (key) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ResourceImageView(
                                type: ResourceType.fromType(key),
                                amount: stock.getByType(key),
                              ),
                              if (stockSimulation != null)
                                SaldoViewShower(
                                    value: stockSimulation[key],
                                    reference: stock.getByType(key),
                                    showValue: true),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}

class SaldoViewShower extends StatelessWidget {
  final int value;
  final int reference;
  final bool showValue;

  SaldoViewShower({this.value, this.reference, this.showValue = true});

  @override
  Widget build(BuildContext context) {
    var up = value - reference > 0;
    var diffValue = value - reference;
    if (value - reference == 0) {
      return Container();
    }
    return Row(children: <Widget>[
      if (up) ...[
        Icon(
          Icons.arrow_upward,
          color: Colors.green,
        ),
        if (showValue) Text(diffValue.toString())
      ],
      if (!up) ...[
        Icon(
          Icons.arrow_downward,
          color: Colors.red,
        ),
        if (showValue) Text(diffValue.toString()),
      ]
    ]);
  }
}
