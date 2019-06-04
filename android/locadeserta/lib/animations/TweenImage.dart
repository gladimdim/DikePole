import 'package:flutter/material.dart';

class TweenImage extends StatefulWidget {
  @override
  _TweenImageState createState() => _TweenImageState();

  final AssetImage first;
  final AssetImage last;
  final int duration;
  final double height;
  final bool repeat;

  TweenImage(
      {@required this.first,
      @required this.last,
      this.duration = 2,
      this.height,
      this.repeat = false});
}

class _TweenImageState extends State<TweenImage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  bool _innerRepeat = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _innerRepeat = widget.repeat;
    _initRepeat(_innerRepeat);
  }

  void _initRepeat(bool repeat) {
    if (repeat) {
      _controller.forward();
      _addRepeatListener();
    } else {
      _stopRepeatListener();
    }
  }

  void _repeatListener(status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    }
    if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  void _addRepeatListener() {
    _controller.addStatusListener(_repeatListener);
  }

  void _stopRepeatListener() {
    _controller.removeStatusListener(_repeatListener);
  }

  void _opaque() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _opaque,
      onLongPress: () {
        _innerRepeat = !_innerRepeat;
        _initRepeat(_innerRepeat);
      },
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - _animation.value,
                child: child,
              );
            },
            child: Image(
              image: widget.first,
              fit: BoxFit.fitHeight,
              height: widget.height,
            ),
          ),
          AnimatedBuilder(
            child: Image(
              image: widget.last,
              fit: BoxFit.fitHeight,
              height: widget.height,
            ),
            animation: _controller,
            builder: (context, child) {
              return Opacity(opacity: _animation.value, child: child);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
