import 'package:scoped_model/scoped_model.dart';


class BaseModel<T> extends Model {
  int stackIndex = 0;
  List<T> entityList = [];
  T entityBeingEdited;

  /// sets the index for the indexed stack
  void setStackIndex(int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }

  /// loads the entries from the [database] and notifies the listeners
  void loadData(database) async {
    entityList.clear();
    entityList.addAll(await database.getAll());
    notifyListeners();
  }
}

/// Sets the chosenDate to be used in the descendants and notifies the listeners
mixin DateSelection on Model {
  String chosenDate;

  void setChosenDate(String date) {
    this.chosenDate = date;
    notifyListeners();
  }
}

/// Similar to [DateSelection] but for the links to be read in the QR Scanner
mixin LinkSelection on Model{
  String chosenLink;

  void setChosenLink(String linkStr) {
    this.chosenLink = linkStr;
    notifyListeners();
  }
}
