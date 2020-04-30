import '../BaseModel.dart';


LinksModel linksModel = LinksModel();

/// Class containing the name and description of the qr link to be scanned
/// along with the id to be used in the database
class ULink { // named like that since class "Link" exists in dart io
  int id;
  String actLink;
  String description;
  bool completed = false;

  bool hasLink() {
    return actLink != null;
  }
}

/// instance of [BaseModel] with the LinkSelection mixin
class LinksModel extends BaseModel<ULink> with LinkSelection {
}
