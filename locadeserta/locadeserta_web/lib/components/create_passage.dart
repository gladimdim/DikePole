import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/animations/slideable_button_web.dart';
import 'package:locadeserta_web/components/components.dart';
import 'package:locadeserta_web/story/Story.dart';

class CreatePassage extends StatefulWidget {
  @override
  _CreatePassageState createState() => _CreatePassageState();
}

class _CreatePassageState extends State<CreatePassage> {
  bool showMenu = false;
  PassageTypes _selectedType;

  @override
  Widget build(BuildContext context) {
    return showMenu ? Text("menu") : DropdownButton<PassageTypes>(
        value: _selectedType,
        onChanged: (PassageTypes newValue) {
          setState(() {
            _selectedType = newValue;
          });
        },
        items: ["Continue", "Random", "Option"].map(stringToPassageType).map((
            option) =>
            DropdownMenuItem(
              value: option,
              child: Text(passageTypeToString(option)),
            ),
        ).toList()
    );
  }
}
