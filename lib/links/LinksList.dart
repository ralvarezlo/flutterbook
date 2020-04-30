import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'LinksDBWorker.dart';
import 'LinksModel.dart' show ULink, LinksModel, linksModel;

class LinksList extends StatelessWidget {
  /// static index that will be used to signal which color will be used for
  /// coloring the items in the gridview
  static num colorPicker = 0;
  /// Collection of colors to be used in the gridview items
  static final colors = [Colors.blueAccent, Colors.lightBlueAccent,
                          Colors.cyanAccent, Colors.greenAccent];

  /// Uses [colorPicker] to iterate through [colors] with a maximum value of 3
  Color iterateColor() {
    colorPicker = (colorPicker+1)%4;
    return colors[colorPicker];
  }

  /// Builds a Scaffold containing a Gridview with containers wrapped in
  /// gesture detectors that on long pressed will delete the entry
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
                  body: GridView.builder(
                    itemCount: linksModel.entityList.length,
                    itemBuilder: (BuildContext context, int index) {
                      ULink task = linksModel.entityList[index];
                      String actLink;
                      if (task.actLink != null) {
                        actLink = task.actLink;
                      }
                      return GestureDetector(
                        child: Container(
                          color: iterateColor(),
                          child: Center(
                            child: Text(
                                "${task.description}",
                                style: task.completed ?
                                TextStyle(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough) :
                                TextStyle(color: Theme.of(context).textTheme.title.color)),
                          ),
                        ),
                        onTap: () async {
                          if (task.completed) {
                            return;
                          }
                          linksModel.entityBeingEdited = await LinksDBWorker.db.get(task.id);
                          if (linksModel.entityBeingEdited.actLink == null) {linksModel.setChosenLink(null);
                          } else {
                            linksModel.setChosenLink(actLink);
                          }
                          linksModel.setStackIndex(1);
                          },
                        onLongPress:() => _deleteULink(context, task),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2
                    ),
                  )
              );
            }
        )
    );
  }

  /// Shows a dialog to delete a [ULink] and notify the database
  /// [LinksDBWorker.db]
  Future _deleteULink(BuildContext context, ULink note) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text('Delete QR Scan'),
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