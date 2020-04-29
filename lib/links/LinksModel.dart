import '../BaseModel.dart';


LinksModel linksModel = LinksModel();

class ULink { // named like that since class "Link" exists in dart io
  int id;
  String actLink;
  String description;
  bool completed = false;

  bool hasLink() {
    return actLink != null;
  }
}

class LinksModel extends BaseModel<ULink> with LinkSelection {
}
