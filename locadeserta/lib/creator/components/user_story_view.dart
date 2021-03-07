import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/animations/slideable_button.dart';
import 'package:locadeserta/creator/components/fat_container.dart';
import 'package:locadeserta/creator/components/user_story_details_view.dart';

class UserStoryView extends StatefulWidget {
  final Story story;

  UserStoryView({required this.story});
  @override
  _UserStoryViewState createState() => _UserStoryViewState();
}

class _UserStoryViewState extends State<UserStoryView> {
  @override
  Widget build(BuildContext context) {
    return SlideableButton(
      child: FatContainer(
        text: widget.story.title,
      ),
      onPress: () async {
        await Navigator.pushNamed(
          context,
          UserStoryDetailsView.routeName,
          arguments: UserStoryDetailsViewArguments(
            story: widget.story,
          ),
        );
      },
    );
  }
}
