import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gladstoriesengine/gladstoriesengine.dart';
import 'package:locadeserta/creator/components/page_next_editor.dart';

class PageNextEdit extends StatelessWidget {
  final PageNext pageNext;
  final Function(PageNext) onDelete;
  final Function(PageNext) onSelect;
  PageNextEdit({
    required this.pageNext,
    required this.onDelete,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: [
        SlideAction(
          child: Icon(Icons.edit),
          onTap: () => onSelect(pageNext),
        )
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 1, child: Icon(Icons.account_tree_sharp)),
          Expanded(
            flex: 10,
            child: PageNextEditor(
              next: pageNext,
            ),
          ),
        ],
      ),
      secondaryActions: [
        SlideAction(
          onTap: () => onDelete(pageNext),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
