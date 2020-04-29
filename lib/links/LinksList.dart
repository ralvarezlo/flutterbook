import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'LinksDBWorker.dart';
import 'LinksModel.dart' show ULink, LinksModel, linksModel;

class LinksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LinksModel>(
        model: linksModel,
        child: ScopedModelDescendant<LinksModel>(
            builder: (BuildContext context, Widget child, LinksModel model) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        linksModel.entityBeingEdited = ULink();
                        linksModel.setStackIndex(1);
                      }
                  ),
                  body: ListView.builder(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      itemCount: linksModel.entityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ULink task = linksModel.entityList[index];
                        String actLink;
                        if (task.actLink != null) {
                          actLink = task.actLink;
                        }
                        return Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Slidable(
                              delegate: SlidableDrawerDelegate(),
                              actionExtentRatio: .25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: "Delete",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => _deleteULink(context, task),
                                )
                              ],

                              child: ListTile(
                                leading: Checkbox(
                                    value: task.completed,
                                    onChanged: (value) async {
                                      task.completed = value;
                                      await LinksDBWorker.db.update(task);
                                      linksModel.loadData(LinksDBWorker.db);
                                    }
                                ),
                                title: Text(
                                    "${task.description}",
                                    style: task.completed ?
                                    TextStyle(color: Theme
                                        .of(context)
                                        .disabledColor,
                                        decoration: TextDecoration.lineThrough) :
                                    TextStyle(color: Theme
                                        .of(context)
                                        .textTheme
                                        .title
                                        .color)),
                                subtitle: task.actLink == null ? null :
                                Text(actLink,
                                    style: task.completed ?
                                    TextStyle(color: Theme
                                        .of(context)
                                        .disabledColor,
                                        decoration: TextDecoration.lineThrough) :
                                    TextStyle(color: Theme
                                        .of(context)
                                        .textTheme
                                        .title
                                        .color)),
                                onTap: () async {
                                  if (task.completed) {
                                    return;
                                  }
                                  linksModel.entityBeingEdited =
                                  await LinksDBWorker.db.get(task.id);
                                  if (linksModel.entityBeingEdited.actLink ==
                                      null) {
                                    linksModel.setChosenLink(null);
                                  } else {
                                    linksModel.setChosenLink(actLink);
                                  }
                                  linksModel.setStackIndex(1);
                                },
                              )
                          ),
                        );
                      }
                  )
              );
            }
        )
    );
  }

  Future _deleteULink(BuildContext context, ULink note) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text('Delete ULink'),
              content: Text('Really delete ${note.description}?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () { Navigator.of(alertContext).pop(); },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    await LinksDBWorker.db.delete(note.id);
                    Navigator.of(alertContext).pop();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('ULink deleted'),
                        )
                    );
                    linksModel.loadData(LinksDBWorker.db);
                  },
                )
              ]
          );
        }
    );
  }
}