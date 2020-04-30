import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'LinksEntry.dart';
import 'LinksModel.dart' show LinksModel, linksModel;
import 'LinksDBWorker.dart';
import 'LinksList.dart';

class Links extends StatelessWidget {
  /// Initializes and gathers the data from the SQLite database [LinksDBWorker]
  Links() {
    linksModel.loadData(LinksDBWorker.db);
  }

  /// Uses an indexed stack to display the child of the given index, the
  /// children are [LinkList] and [LinksEntry]
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LinksModel>(
        model: linksModel,
        child: ScopedModelDescendant<LinksModel>(
            builder: (BuildContext context, Widget child, LinksModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[LinksList(), LinksEntry()],
              );
            }
        )
    );
  }
}