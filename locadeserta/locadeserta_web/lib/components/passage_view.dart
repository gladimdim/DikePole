import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/animations/slideable_button_web.dart';
import 'package:locadeserta_web/components/bordered_random_image.dart';
import 'package:locadeserta_web/models/background_image_web.dart';
import 'package:locadeserta_web/story/Story.dart';
import 'package:locadeserta_web/components/components.dart';
import 'package:tuple/tuple.dart';

class PassageView extends StatefulWidget {
  final Story currentStory;

  PassageView({
    this.currentStory,
  });

  @override
  State<StatefulWidget> createState() => PassageState();
}

class PassageState extends State<PassageView> with TickerProviderStateMixin {
  ScrollController _passageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextRow(context),
        ..._createButtons(context),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  List<Widget> _createButtons(BuildContext context) {
    switch (widget.currentStory.currentPassage.type) {
      case ContinueTypes.Continue:
        return [createContinue(context)];
      case ContinueTypes.Random:
        return [createContinue(context)];
      case ContinueTypes.Option:
        {
          PassageOption option =
              widget.currentStory.currentPassage as PassageOption;
          return createOptionList(option.options);
        }
    }
    return [];
  }

  Widget createButton(String text, int i) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.075,
        child: SlideableButton(
          onPress: () {
            _next(i);
          },
          child: optionBox(
            context,
            text,
          ),
        ),
      ),
    );
  }

  void _next(int i) {
    setState(() {
      widget.currentStory.next(i);
    });
  }

  List<Widget> createOptionList(List<Tuple2<int, String>> options) {
    List<Widget> optionButtons = List();
    int index = 0;
    optionButtons.addAll(options.map((value) {
      return createButton(value.item2, index++);
    }));

    return optionButtons;
  }

  Widget createContinue(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SlideableButton(
          child: optionBox(
            context,
            "Далі",
          ),
          onPress: () {
            _next(null);
          }),
    );
  }

  Widget _buildTextRow(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), _scroll(context));
    return Expanded(
      child: SingleChildScrollView(
        controller: _passageScrollController,
        child: PassageItemView(widget.currentStory.currentPassage),
      ),
    );
  }

  _scroll(BuildContext context) {
    return () {
      if (_passageScrollController.hasClients) {
        var position = _passageScrollController.position;
        _passageScrollController.animateTo(
          position.maxScrollExtent,
          duration: Duration(milliseconds: 50),
          curve: Curves.easeOutBack,
        );
      }
    };
  }
}

class PassageItemView extends StatelessWidget {
  final PassageBase passage;

  PassageItemView(this.passage);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        if (passage.imagePath != null)
          BorderedRandomImageByPath(
            getImagesForType(passage.imagePath),
            size,
          ),
        Text(passage.text),
      ],
    );
  }
}
