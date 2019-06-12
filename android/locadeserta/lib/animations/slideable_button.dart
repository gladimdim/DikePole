import 'package:flutter/material.dart';

class SlideableButton extends StatefulWidget {
  final Widget child;
  final Function onPress;

  SlideableButton({
    @required this.child,
    @required this.onPress,
  });

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
          child: InkWell(
              child: child,
              onTap: () {
                controller.forward();
              }),
        );
      },
    );
  }
}
