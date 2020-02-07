import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
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
    return SlideableButton(
      child: Container(
        height: 64,
        child: SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  buildingIconPath,
                ),
                TitleText(
                  title,
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      producesIconPath,
                      height: 32,
                    ),
                    Text(
                      ' $amount',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    HDivider(),
                    Image.asset(
                      'images/ui/arrow_right.png',
                      height: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onPress: onPress,
    );
  }
}
