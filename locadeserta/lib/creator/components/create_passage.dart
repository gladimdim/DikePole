import 'package:flutter/material.dart';
import 'package:locadeserta/creator/story/Story.dart';

class CreatePassage extends StatefulWidget {

  final Function onAdd;

  CreatePassage({@required this.onAdd});

  @override
  _CreatePassageState createState() => _CreatePassageState();
}

class _CreatePassageState extends State<CreatePassage> {
  bool showMenu = false;
  PassageTypes _selectedType = PassageTypes.Continue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        DropdownButton<PassageTypes>(
            value: _selectedType,
            onChanged: (PassageTypes newValue) {
              setState(() {
                _selectedType = newValue;
              });
            },
            items: ["Continue", "Random", "Option"]
                .map(stringToPassageType)
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(passageTypeToString(option)),
                  ),
                )
                .toList()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => widget.onAdd(_selectedType),
        )
      ],
    );
  }
}
