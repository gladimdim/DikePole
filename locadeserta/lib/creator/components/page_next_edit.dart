import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/creator/components/page_next_editor.dart';

class PageNextEdit extends StatelessWidget {
  final PageNext pageNext;
  final Function(PageNext) onDelete;
  PageNextEdit({required this.pageNext, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      child: Expanded(
        flex: 10,
        child: PageNextEditor(
          next: pageNext,
        ),
      ),
      secondaryActions: [
        IconButton(
          onPressed: () => onDelete(pageNext),
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
