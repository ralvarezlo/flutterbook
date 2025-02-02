import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'LinksDBWorker.dart';
import 'LinksModel.dart';
import '../utils.dart' show scanQR;

class LinksEntry extends StatelessWidget {

  final TextEditingController _descriptionEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Initializes and sets a listener pertaining to the description of the entity
  /// being edited using a text controller
  LinksEntry() {
    _descriptionEditingController.addListener(() {
      linksModel.entityBeingEdited.description = _descriptionEditingController.text;
    });
  }

  /// Builds a scaffold as a [ScopedModelDescendant] containing the entrypoints
  /// for the information of an ULink using a QR Scanner
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LinksModel>(
      model: linksModel,
      child: ScopedModelDescendant<LinksModel>(
          builder: (BuildContext context, Widget child, LinksModel model) {
            if (model.entityBeingEdited != null) {
              _descriptionEditingController.text =
                  model.entityBeingEdited.description;
            }

            return Scaffold(
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Row(
                        children: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              model.setStackIndex(0);
                            },
                          ),
                          Spacer(),
                          FlatButton(
                            child: Text('Save'),
                            onPressed: () {
                              _save(context, linksModel);
                            },
                          )
                        ]
                    )
                ),
                body: Form(
                    key: _formKey,
                    child: ListView(
                        children: [
                          ListTile(
                              leading: Icon(Icons.text_fields),
                              title: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  decoration: InputDecoration(hintText: 'Description'),
                                  controller: _descriptionEditingController,
                                  validator: (String value) {
                                    if (value.length == 0) {
                                      return 'Please enter a description for the link';
                                    }
                                    return null;
                                  }
                              )
                          ),
                          ListTile(
                            leading: Icon(Icons.link),
                            title: Text("Read QR"),
                            subtitle: Text(_actLink()),
                            trailing: IconButton(
                              icon: Icon(Icons.camera_alt),
                              color: Colors.blue,
                              onPressed: () async {
                                print("Edit Pressed");
                                String chosenLink = await scanQR(context, linksModel,
                                    linksModel.entityBeingEdited.actLink);
                                if (chosenLink != null) {
                                  linksModel.entityBeingEdited.actLink = chosenLink;
                                }
                              },
                            ),
                          )
                        ]
                    )
                )
            );
          }
      ),
    );
  }


  /// if the entity isn't null and has a qr link read it returns that link,
  /// otherwise it returns empty
  String _actLink() {
    if (linksModel.entityBeingEdited != null && linksModel.entityBeingEdited.hasLink()) {
      return linksModel.entityBeingEdited.actLink;
    }
    return '';
  }

  /// Saves the entity in the database
  void _save(BuildContext context, LinksModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (model.entityBeingEdited.id == null) {
      await LinksDBWorker.db.create(linksModel.entityBeingEdited);
    } else {
      await LinksDBWorker.db.update(linksModel.entityBeingEdited);
    }
    linksModel.loadData(LinksDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Task saved'),
        )
    );
  }
}