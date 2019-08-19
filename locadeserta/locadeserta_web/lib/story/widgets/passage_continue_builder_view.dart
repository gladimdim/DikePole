import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/story_builder.dart';
import 'package:locadeserta_web/utils/utils.dart';

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
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(firstNCharsFromString(widget.passage.text, 35)),
            subtitle: Text("Тип: ${widget.passage.type.toString()}"),
          ),
          EditableText(
            cursorColor: Colors.black,
            backgroundCursorColor: Colors.white,
            focusNode: FocusNode(),
            maxLines: 5,
            style: Theme.of(context).textTheme.title,
            controller: _controller,
            onChanged: (newValue) {
              setState(() {
                widget.passage.text = newValue;
                print(widget.passage.text);
              });
            },
          ),
          Row(
            children: <Widget>[
              Text("Linked to: "),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.4,
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
                          if (passage.text != null) Text(firstNCharsFromString(passage.text, 25)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
