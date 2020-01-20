import 'package:flutter/material.dart';
import 'package:locadeserta/city_building/models/resources/resource.dart';
import 'package:locadeserta/city_building/models/stock.dart';

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
            return Text(
              '${resourceTypesToString(key)}: ${stock.getByType(key)} ',
              style: TextStyle(
                fontSize: 12,
              ),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Stock',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          ...stock.getResourceTypesKeys().map<Widget>((key) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  '${resourceTypesToImagePath(key)}',
                  height: 64,
                ),
                Text(stock.getByType(key).toString()),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
