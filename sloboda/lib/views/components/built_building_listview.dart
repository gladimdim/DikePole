import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/views/components/soft_container.dart';

class BuiltBuildingListView extends StatelessWidget {
  final VoidCallback onPress;
  final String buildingIconPath;
  final String title;
  final String producesIconPath;
  final int amount;

  BuiltBuildingListView(
      {this.onPress,
      @required this.buildingIconPath,
      @required this.title,
      @required this.producesIconPath,
      this.amount = 1});

  @override
  Widget build(BuildContext context) {
    return SoftContainer(
      child: SlideableButton(
        child: Container(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  buildingIconPath,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      producesIconPath,
                      height: 32,
                    ),
                    Text(
                      'x $amount',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ],
            ),
          ),
        ),
        onPress: onPress,
      ),
    );
  }
}
