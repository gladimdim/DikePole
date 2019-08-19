import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/story_builder.dart';

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
                      widget.passage.next = [newValue];
                    });
                  },
                  value: 1,
                  items: widget.storyBuilder.getPassages().map((passage) {
                    var hasText = passage.text != null;
                    var takeMax4 = 4;
                    var substract = "";
                    if (hasText) {
                      takeMax4 = passage.text.length > 4
                          ? takeMax4
                          : passage.text.length;
                      substract = passage.text.substring(0, takeMax4);
                    }
                    print("next: ${widget.passage.next}, passage.id: ${passage.id}");
                    print(widget.passage.next.contains(passage.id));
                    return DropdownMenuItem(
                      value: passage.id,
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: widget.passage.next.contains(passage.id),
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue && !widget.passage.next.contains(passage.id)) {
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
