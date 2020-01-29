import 'package:flutter/material.dart';

class SlideableButton extends StatefulWidget {
  final Widget child;
  final Function onPress;
  final Direction direction;
  final Duration duration;

  SlideableButton({
    @required this.child,
    @required this.onPress,
    this.direction = Direction.Right,
    this.duration = const Duration(milliseconds: 200),
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
      duration: widget.duration,
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          if (widget.onPress != null) {
            widget.onPress();
          }
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
    var width = MediaQuery.of(context).size.width * 2;
    final end = widget.direction == Direction.Right ? width : -width;
    final animation = Tween(begin: 0.0, end: end).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.button,
      child: AnimatedBuilder(
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
      ),
    );
  }
}

enum Direction {
  Left,
  Right,
}
