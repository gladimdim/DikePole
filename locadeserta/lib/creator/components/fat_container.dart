import 'package:flutter/material.dart';

class FatContainer extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  FatContainer({@required this.text, this.backgroundColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.075;
    return SizedBox(
      height: height,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
