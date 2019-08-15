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
        Column(
          children: <Widget>[
            Text("Id"),
            Text(
              widget.passage.id.toString(),
            ),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Input text of the passage",
            ),
            controller: _controller,
            onChanged: (newValue) {
              setState(() {
                widget.passage.text = newValue;
                print(widget.passage.text);
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Column(
          children: <Widget>[
            Text("Next"),
            SizedBox(
                height: 100,
                width: 100,
                child: DropdownButton(
                  onChanged: (int newValue) {
                    setState(() {
                      widget.passage.next = newValue;
                    });
                  },
                  value: widget.passage.next,
                  items: widget.storyBuilder.getPassages().map((passage) {
                    var hasText = passage.text != null;
                    var takeMax10 = 10;
                    var substract = "";
                    if (hasText) {
                      takeMax10 = passage.text.length > 10
                          ? takeMax10
                          : passage.text.length;
                      substract = passage.text.substring(0, takeMax10);
                    }

                    return DropdownMenuItem(
                      value: passage.id,
                      child: Row(
                        children: <Widget>[
                          Text("${passage.id.toString()}: "),
                          SizedBox(width: 3),
                          if (passage.text != null) Text(substract),
                        ],
                      ),
                    );
                  }).toList(),
                )),
          ],
        ),
      ],
    );
  }
}
