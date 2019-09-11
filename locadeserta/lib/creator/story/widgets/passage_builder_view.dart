import 'package:flutter/material.dart';
import 'package:locadeserta/creator/story/story.dart';
import 'package:locadeserta/creator/story/story_builder.dart';
import 'package:locadeserta/creator/utils/utils.dart';

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
            flex: 6,
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
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                controller: _controller,
                onChanged: (newValue) {
                  setState(() {
                    widget.passage.text = newValue;
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: widget.nextBlock,
          ),
        ],
      ),
    );
  }
}

class PassageOptionBuilderView extends StatefulWidget {
  @override
  _PassageOptionBuilderViewState createState() =>
      _PassageOptionBuilderViewState();

  final PassageBuilderOption passage;
  final StoryBuilder storyBuilder;

  PassageOptionBuilderView({this.passage, this.storyBuilder});
}

class _PassageOptionBuilderViewState extends State<PassageOptionBuilderView> {
  String newOptionValue = "";
  int newNextValue = 0;

  @override
  Widget build(BuildContext context) {
    return PassageBuilderView(
      storyBuilder: widget.storyBuilder,
      passage: widget.passage,
      nextBlock: Column(children: [
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (value) {
                  newOptionValue = value;
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: DropdownButton(
                onChanged: (id) {
                  newNextValue = id;
                },
                value: newNextValue,
                items: widget.storyBuilder.getPassages().map((passage) {
                  return DropdownMenuItem(
                    value: passage.id,
                    child: Row(
                      children: <Widget>[
                        if (passage.text != null)
                          Text(firstNCharsFromString(passage.text, 20)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Icon(Icons.add),
                onTap: () {
                  setState(
                    () {
                      widget.passage.next.add(
                        NextOption(text: newOptionValue, target: newNextValue),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.passage.next.map((next) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Option: ${next.text} -> ",
                  ),
                  Text(
                    "${widget.storyBuilder.passageById(next.target).text}",
                  ),
                  InkWell(
                    child: Icon(Icons.delete),
                    onTap: () {
                      setState(() {
                        widget.passage.next.remove(next);
                      });
                    },
                  )
                ],
              );
            }).toList()),
      ]),
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
              value: widget.passage.next == null ? 0 : widget.passage.next,
              items: widget.storyBuilder.getPassages().map((passage) {
                return DropdownMenuItem(
                  value: passage.id,
                  child: Row(
                    children: <Widget>[
                      if (widget.passage.next == passage.id) Icon(Icons.check),
                      if (passage.text != null)
                        Text(firstNCharsFromString(passage.text, 20)),
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
