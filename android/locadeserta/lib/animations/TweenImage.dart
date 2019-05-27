import 'package:flutter/material.dart';

class TweenImage extends StatefulWidget {
  @override
  _TweenImageState createState() => _TweenImageState();

  final AssetImage first;
  final AssetImage last;
  final int duration;
  final double height;
  final bool repeat;

  TweenImage({@required this.first, @required this.last, this.duration = 1, this.height, this.repeat=false});
}

class _TweenImageState extends State<TweenImage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
  }

  void _opaque() {
    setState(() {
      _opacity = _opacity == 0.0 ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _opaque,
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(seconds: widget.duration),
            opacity: 1.0 - _opacity,
            child: Image(
              image: widget.first,
              fit: BoxFit.fitHeight,
              height: widget.height,
            ),
          ),
          AnimatedOpacity(
            duration: Duration(seconds: widget.duration),
            opacity: _opacity,
            child: Image(
              image: widget.last,
              fit: BoxFit.fitHeight,
              height: widget.height,
            ),
          )
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
