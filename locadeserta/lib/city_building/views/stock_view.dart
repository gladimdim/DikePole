import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/stock.dart';
import 'package:locadeserta/city_building/views/components/lined_container.dart';
import 'package:locadeserta/extensions/list.dart';

class StockMiniView extends StatelessWidget {
  final Stock stock;

  StockMiniView({this.stock});

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
                  '${stock.getByType(key)} ',
                  style: TextStyle(
                    fontSize: 12,
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

class StockFullView extends StatelessWidget {
  final Stock stock;

  StockFullView({this.stock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                            Image.asset(
                              '${resourceTypesToImagePath(key)}',
                              height: 64,
                            ),
                            Text(stock.getByType(key).toString()),
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
    );
  }
}

