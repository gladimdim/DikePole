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
                    print(widget.passage.text);
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
