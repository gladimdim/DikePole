import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class TweenImage extends StatefulWidget {
  @override
  _TweenImageState createState() => _TweenImageState();

  final AssetImage first;
  final AssetImage last;
  final int duration;
  final double? height;
  final double? width;
  final BoxFit imageFit;
  final bool repeat;

  TweenImage(
      {required this.first,
      required this.last,
      this.duration = 2,
      this.height,
      this.width,
      this.imageFit = BoxFit.fitHeight,
      this.repeat = false});
}

class _TweenImageState extends State<TweenImage> {
  late Playback playback;

  @override
  initState() {
    if (widget.repeat) {
      playback = Playback.MIRROR;
    } else {
      playback = Playback.PLAY_FORWARD;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _updatePlayback();
      },
      child: ControlledAnimation(
        playback: playback,
        duration: Duration(seconds: widget.duration),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, double value) => Stack(
          children: <Widget>[
            Opacity(
              opacity: 1.0 - value,
              child: Image(
                image: widget.first,
                fit: widget.imageFit,
                height: widget.height,
              ),
            ),
            Opacity(
              opacity: value,
              child: Image(
                image: widget.last,
                fit: widget.imageFit,
                height: widget.height,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePlayback() {
    if (playback == Playback.MIRROR) {
      playback = Playback.PAUSE;
    } else {
      playback = Playback.MIRROR;
    }
  }
}
