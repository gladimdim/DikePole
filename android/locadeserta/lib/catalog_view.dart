import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadeserta/models/catalogs.dart';

import 'models/Localizations.dart';

class CatalogView extends StatefulWidget {
  @override
  _CatalogViewState createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  void onStorySelected(CatalogStory story) {
    Navigator.pop(context, story);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LDLocalizations.of(context).availableStories),
      ),
      body: Center(
        child: _buildCatalogView(),
      ),
    );
  }

  Widget _buildCatalogView() {
    return StreamBuilder(
        stream: Firestore.instance.collection('catalog').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildCatalogList(snapshot.data.documents);
          } else {
            return LinearProgressIndicator();
          }
        });
  }

  Widget _buildCatalogList(List<DocumentSnapshot> documents) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: documents.map((data) => _buildCatalogItem(data)).toList(),
    );
  }

  Widget _buildCatalogItem(DocumentSnapshot data) {
    final story = CatalogStory.fromSnapshot(data);
    return ListTile(
      onTap: () => onStorySelected(story),
      title: Text(story.title),
      subtitle: Text(story.description),
    );
  }
}
