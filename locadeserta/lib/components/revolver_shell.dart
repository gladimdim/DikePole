import 'package:flutter/widgets.dart';

class RevolverShell extends StatefulWidget {
  final Widget top;
  final Widget bottom;
  final Widget middle;
  final double animationValue;

  RevolverShell(
      {this.top, this.bottom, this.middle, this.animationValue = 0.0});

  @override
  _RevolverShellState createState() => _RevolverShellState();
}

class _RevolverShellState extends State<RevolverShell> {
  Widget _animatedWidget;

  @override
  Widget build(BuildContext context) {
    print(widget.animationValue);
    if (widget.animationValue > 0.5 && widget.animationValue <= 1) {
      _animatedWidget = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Opacity(
            opacity: 1 - widget.animationValue,
            child: widget.middle,
          ),
          Opacity(
            opacity: widget.animationValue,
            child: widget.top,
          ),
        ],
      );
    } else {
      _animatedWidget = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.top,
          widget.middle,
          widget.bottom,
        ],
      );
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: _animatedWidget,
    );
  }
}
