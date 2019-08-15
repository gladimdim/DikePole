import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/story_builder.dart';

class PassageContinueBuilderView extends StatefulWidget {
  final PassageBuilderContinue passage;
  final StoryBuilder storyBuilder;

  @override
  _PassageContinueBuilderViewState createState() =>
      _PassageContinueBuilderViewState();

  PassageContinueBuilderView({this.passage, this.storyBuilder});
}

class _PassageContinueBuilderViewState
    extends State<PassageContinueBuilderView> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.passage.text;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          widget.passage.id.toString(),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (newValue) {
              setState(() {
                widget.passage.text = newValue;
                print(widget.passage.text);
              });
            },
          ),
        ),
        DropdownButton(
          onChanged: (int newValue) {
            setState(() {
              widget.passage.next = newValue;
            });
          },
          value: widget.passage.next,
          items: widget.storyBuilder
              .getAllIds()
              .map((id) => DropdownMenuItem(
                    value: id,
                    child: Text(
                      id.toString(),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
