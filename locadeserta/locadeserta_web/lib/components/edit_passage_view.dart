import 'package:flutter_web/material.dart';
import 'package:locadeserta_web/story/story_builder.dart';

class EditPassageView extends StatelessWidget {
  final StoryBuilder story;
  final PassageBuilderBase passageBuilder;

  EditPassageView({this.story, this.passageBuilder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: passageBuilder.toEditWidget(story),
      appBar: AppBar(
        title: Text("Editing passage"),
      ),
    );
  }
}

class EditPassageViewArguments {
  final StoryBuilder story;
  final PassageBuilderBase passageBuilder;

  EditPassageViewArguments({this.story, this.passageBuilder});
}

class ExtractEditPassageView extends StatelessWidget {
  static const routeName = "/editPassage";

  Widget build(BuildContext context) {
    final EditPassageViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return EditPassageView(
      story: args.story,
      passageBuilder: args.passageBuilder,
    );
  }
}
