import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/story_builder.dart';
import 'package:locadeserta_web/utils/utils.dart';

class PassageBuilderView extends StatefulWidget {
  final PassageBuilderBase passage;
  final StoryBuilder storyBuilder;
  final Widget nextBlock;

  @override
  _PassageBuilderViewState createState() => _PassageBuilderViewState();

  PassageBuilderView({this.passage, this.storyBuilder, this.nextBlock});
}

class _PassageBuilderViewState extends State<PassageBuilderView> {
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
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListTile(
              title: Text(firstNCharsFromString(widget.passage.text, 35)),
              subtitle: Text("Type: ${widget.passage.type.toString()}"),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3.0,
                ),
              ),
              child: EditableText(
                cursorColor: Colors.black,
                backgroundCursorColor: Colors.white,
                focusNode: FocusNode(),
                maxLines: 10,
                style: Theme.of(context).textTheme.title,
                controller: _controller,
                onChanged: (newValue) {
                  setState(() {
                    widget.passage.text = newValue;
                  });
                },
              ),
            ),
          ),
          widget.nextBlock,
        ],
      ),
    );
  }
}

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
    return PassageBuilderView(
      passage: widget.passage,
      storyBuilder: widget.storyBuilder,
      nextBlock: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text("Next:"),
          ),
          Expanded(
            flex: 8,
            child: DropdownButton(
              onChanged: (int newValue) {
                setState(() {
                  widget.passage.next = newValue;
                });
              },
              value: widget.passage.next,
              items: widget.storyBuilder.getPassages().map((passage) {
                return DropdownMenuItem(
                  value: passage.id,
                  child: Row(
                    children: <Widget>[
                      if (passage.text != null)
                        Text(firstNCharsFromString(passage.text, 25)),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class PassageRandomBuilderView extends StatefulWidget {
  final PassageBuilderRandom passage;
  final StoryBuilder storyBuilder;

  @override
  _PassageRandomBuilderViewState createState() =>
      _PassageRandomBuilderViewState();

  PassageRandomBuilderView({this.passage, this.storyBuilder});
}

class _PassageRandomBuilderViewState extends State<PassageRandomBuilderView> {
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
    return PassageBuilderView(
      storyBuilder: widget.storyBuilder,
      passage: widget.passage,
      nextBlock: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text("Next:"),
          ),
          Expanded(
            flex: 9,
            child: DropdownButton(
              onChanged: (int newValue) {
                setState(() {
                  widget.passage.next = [newValue];
                });
              },
              value: 1,
              items: widget.storyBuilder.getPassages().map((passage) {
                return DropdownMenuItem(
                  value: passage.id,
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: widget.passage.next.contains(passage.id),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue &&
                                !widget.passage.next.contains(passage.id)) {
                              widget.passage.next.add(passage.id);
                            } else {
                              widget.passage.next
                                  .removeWhere((i) => i == passage.id);
                            }
                          });
                        },
                      ),
                      Text("${passage.id.toString()}: "),
                      SizedBox(width: 3),
                      if (passage.text != null)
                        Text(firstNCharsFromString(passage.text, 25)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
