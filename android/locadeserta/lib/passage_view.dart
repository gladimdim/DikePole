import 'dart:math';
import 'package:flutter/material.dart';
import 'package:locadeserta/story_bridge.dart';

class Passage extends StatefulWidget {
  final Story currentStory;
  final random = new Random().nextInt(7);
  final Function(String pid, int i) onNextOptionSelected;

  Passage({this.currentStory, this.onNextOptionSelected});

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<Passage> with TickerProviderStateMixin {
  Widget createButton(String text, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
          height: 100.0,
          child: RaisedButton(
            color: Colors.black, // [50 * (i + 1)],
            onPressed: () {
              widget.onNextOptionSelected(text, i);
            },
            child: Text(
              text,
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          )),
    );
  }

  List<Widget> createOptionList(List<String> options) {
    List<Widget> optionButtons = new List();
    int index = 0;
    optionButtons.addAll(options.map((value) {
      return createButton(value, index++);
    }));

    return optionButtons;
  }

  Widget createContinue() {
    return SlideableButton(
      buttonText: "Далі",
      onPress: () => widget.onNextOptionSelected("Next", -1),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List();

    list.addAll(
      [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Card(
                  elevation: 0.0,
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.4,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                    "images/background/boat_" +
                                        widget.random.toString() +
                                        ".jpg",
                                  ))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.currentStory.currentText,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );

    final buttons = widget.currentStory.canContinue == true
        ? [createContinue()]
        : createOptionList(widget.currentStory.currentChoices);
    list.addAll(buttons);
    return Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}

class SlideableButton extends StatefulWidget {
  final Widget child;
  Function onPress;
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
      duration: Duration(milliseconds: 3000),
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
    final animation = Tween(begin: 0.0, end: 1000.0).animate(CurvedAnimation(
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
                  color: Colors.black87,
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    controller.forward();
                  }),
            ),
          );
        });
  }
}
