import 'package:sqflite/sqflite.dart';
import 'LinksModel.dart';

class LinksDBWorker {

  static final LinksDBWorker db = LinksDBWorker._();

  static const String DB_NAME = 'links.db';
  static const String TBL_NAME = 'links';
  static const String KEY_ID = 'id';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_ACT_LINK = 'actLink';
  static const String KEY_COMPLETED = 'completed';

  Database _db;

  LinksDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  /// Initializes the SQLite database with a table representing the structure of
  /// [ULink]
  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_DESCRIPTION TEXT,"
                  "$KEY_ACT_LINK TEXT,"
                  "$KEY_COMPLETED INTEGER"
                  ")"
          );
        }
    );
  }

  /// Creates an entry of [ULink] in the database table.
  @override
  Future<int> create(ULink ulink) async {
    Database db = await database;
    return await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_DESCRIPTION, $KEY_ACT_LINK, $KEY_COMPLETED) "
            "VALUES (?, ?, ?)",
        [ulink.description, ulink.actLink, ulink.completed ? 1 : 0]
    );
  }

  /// Given the [id], it deletes the corresponding entry
  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  /// given the [id] it returns the corresponding [ULink] entry
  @override
  Future<ULink> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _ulinkFromMap(values.first);
  }

  /// Gets all the stored [ULink] from the table [TBL_NAME]
  @override
  Future<List<ULink>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _ulinkFromMap(m)).toList() : [];
  }

  /// Updates the entry of the given [ULink]
  @override
  Future<void> update(ULink ulink) async {
    Database db = await database;
    await db.update(TBL_NAME, _ulinkToMap(ulink),
        where: "$KEY_ID = ?", whereArgs: [ulink.id]);
  }

  /// Creates a [ULink] instance given the map
  ULink _ulinkFromMap(Map<String, dynamic> map) {
    return ULink()
      ..id = map[KEY_ID]
      ..description = map[KEY_DESCRIPTION]
      ..actLink = map[KEY_ACT_LINK]
      ..completed = map[KEY_COMPLETED] != 0;
  }

  /// Creates a map of strigns given an [ULink] instance
  Map<String, dynamic> _ulinkToMap(ULink ulink) {
    return Map<String, dynamic>()
      ..[KEY_ID] = ulink.id
      ..[KEY_DESCRIPTION] = ulink.description
      ..[KEY_ACT_LINK] = ulink.actLink
      ..[KEY_COMPLETED] = ulink.completed ?  1 : 0;
  }
}