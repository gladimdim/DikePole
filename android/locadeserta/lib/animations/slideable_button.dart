import 'package:flutter/material.dart';

class SlideableButton extends StatefulWidget {
  final Widget child;
  final Function onPress;
  final String buttonText;

  SlideableButton({this.child, this.onPress, this.buttonText});

  @override
  _SlideableButtonState createState() => _SlideableButtonState();
}

class _SlideableButtonState extends State<SlideableButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          widget.onPress();
          controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 2;
    final animation = Tween(begin: 0.0, end: width).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
        animation: animation,
        child: widget.child,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(animation.value, 0.0),
            child: SizedBox(
              height: 100.0,
              child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).textTheme.title.color),
                  ),
                  onPressed: () {
                    controller.forward();
                  }),
            ),
          );
        });
  }
}