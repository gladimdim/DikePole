import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/stock.dart';
import 'package:locadeserta/city_building/views/components/lined_container.dart';
import 'package:locadeserta/city_building/views/resource_view.dart';
import 'package:locadeserta/extensions/list.dart';

class StockMiniView extends StatelessWidget {
  final Stock stock;
  final Map<RESOURCE_TYPES, int> simulation;

  StockMiniView({@required this.stock, @required this.simulation});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Row(
          children: stock.getResourceTypesKeys().map<Widget>((key) {
            return Row(
              children: <Widget>[
                Image.asset(
                  resourceTypesToImagePath(key),
                  width: 24,
                ),
                Text(
                  '${resourceTypesToString(key)}: ${stock.getByType(key)} ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                if (simulation[key] > 0) Icon(Icons.arrow_upward, color: Colors.green,),
                if (simulation[key] < 0) Icon(Icons.arrow_downward, color: Colors.red,),
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
  final Map<RESOURCE_TYPES, int> simulation;

  StockFullView({@required this.stock, @required this.simulation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Stock',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            ...stock.getResourceTypesKeys().divideBy(2).map<Widget>(
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
                                type: key,
                                amount: stock.getByType(key),
                              ),
                              if (simulation[key] > 0) ...[
                                Icon(Icons.arrow_upward, color: Colors.green,),
                                Text(simulation[key].toString())
                              ],
                              if (simulation[key] < 0) ...[
                                Icon(Icons.arrow_downward, color: Colors.red,),
                                Text(simulation[key].toString()),
                              ]
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
