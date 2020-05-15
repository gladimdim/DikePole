import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart' as gse;
import 'package:locadeserta/components/app_bar_custom.dart';
import 'package:locadeserta/components/bordered_container.dart';
import 'package:locadeserta/components/narrow_scaffold.dart';
import 'package:locadeserta/creator/components/edit_story.dart';
import 'package:locadeserta/models/Localizations.dart';

import 'file:///C:/Users/gladi/projects/DikePole/locadeserta/lib/models/story_persistence.dart';

class UserStoryDetailsView extends StatefulWidget {
  static String routeName = "/userStoryDetailsView";
  final gse.Story story;

  UserStoryDetailsView({this.story});

  @override
  _UserStoryDetailsViewState createState() => _UserStoryDetailsViewState();
}

class _UserStoryDetailsViewState extends State<UserStoryDetailsView> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description;
  String _authors;
  int _year;

  @override
  void initState() {
    super.initState();
    if (widget.story != null && widget.story.year != null) {
      _year = widget.story.year;
    } else {
      _year = 1620;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NarrowScaffold(
      title: LDLocalizations.edit,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (widget.story != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  widget.story.title,
                ),
              ),
            BorderedContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.title,
                            color: Theme.of(context).iconTheme.color),
                        hintText: LDLocalizations.enterStoryTitle,
                        labelText: LDLocalizations.labelStoryTitle,
                      ),
                      initialValue:
                          widget.story == null ? "" : widget.story.title,
                      onSaved: (value) {
                        _title = value;
                      },
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.description,
                            color: Theme.of(context).iconTheme.color),
                        hintText: LDLocalizations.hintDescription,
                        labelText: LDLocalizations.description,
                      ),
                      onSaved: (value) {
                        _description = value;
                      },
                      minLines: 1,
                      maxLines: 5,
                      initialValue:
                          widget.story == null ? "" : widget.story.description,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person,
                            color: Theme.of(context).iconTheme.color),
                        hintText: LDLocalizations.listOfAuthors,
                        labelText: LDLocalizations.labelAuthors,
                      ),
                      onSaved: (value) {
                        _authors = value;
                      },
                      initialValue:
                          widget.story == null ? "" : widget.story.authors,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: LDLocalizations.hintFieldYear,
                        labelText: LDLocalizations.labelYear,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onSaved: (value) {
                        _year = int.parse(value);
                      },
                      initialValue: "$_year",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.save,
                                size: 30.0,
                              ),
                              onPressed: () {
                                _formKey.currentState.save();
                                var story;
                                if (widget.story == null) {
                                  story = gse.Story(
                                    title: _title,
                                    description: _description,
                                    authors: _authors,
                                    root: gse.Page.generate(),
                                  );
                                } else {
                                  story = widget.story;
                                  story.title = _title;
                                  story.description = _description;
                                  story.authors = _authors;
                                  story.year = _year;
                                }
                                _onSave(story);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 30,
                              ),
                              onPressed: () {
                                _goToEditStoryView(widget.story, context);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 30,
                              ),
                              onPressed: () {
                                _deleteStory(widget.story);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppBarObject(
          text: LDLocalizations.backToStories,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        AppBarObject(
          text: LDLocalizations.save,
          onTap: () async {
            await StoryPersistence.instance.writeStory(widget.story);
          },
        ),
      ],
    );
  }

  _onSave(gse.Story newStory) async {
    await StoryPersistence.instance.writeCreatorStory(newStory);
  }

  _deleteStory(gse.Story story) async {
    return await StoryPersistence.instance.deleteCreatorStory(story);
  }

  _goToEditStoryView(gse.Story story, context) async {
    await Navigator.pushNamed(context, ExtractEditStoryViewArguments.routeName,
        arguments: EditStoryViewArguments(story: story));
  }
}

class UserStoryDetailsViewArguments {
  final gse.Story story;

  UserStoryDetailsViewArguments({this.story});
}

class ExtractUserStoryDetailsViewArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final UserStoryDetailsViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return UserStoryDetailsView(
      story: args.story,
    );
  }
}
