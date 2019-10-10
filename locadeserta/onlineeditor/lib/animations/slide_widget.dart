import 'package:flutter/material.dart';

class SlideWidget extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final bool slide;

  @override
  _SlideWidgetState createState() => _SlideWidgetState();

  SlideWidget({@required this.child, @required this.direction, this.slide});
}

class _SlideWidgetState extends State<SlideWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slide) {
      _controller.forward();
    }
    final height = MediaQuery.of(context).size.height;
    final animation = Tween(begin: height, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, animation.value),
          child: child,
        );
      },
    );
  }
}

enum SlideDirection { Top, Down, Left, Right }
