import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableWords = 'words';
final String columnId = '_id';
final String columnWord = 'word';
final String columnFrequency = 'frequency';

// data model class
// class Word {

//   int id;
//   String word;
//   int frequency;

//   Word();

//   // convenience constructor to create a Word object
//   Word.fromMap(Map<String, dynamic> map) {
//     id = map[columnId];
//     word = map[columnWord];
//     frequency = map[columnFrequency];
//   }

//   // convenience method to create a Map from this Word object
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       columnWord: word,
//       columnFrequency: frequency
//     };
//     if (id != null) {
//       map[columnId] = id;
//     }
//     return map;
//   }
// }

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Goalzz.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableWords (
            $columnId INTEGER PRIMARY KEY,
            $columnWord TEXT NOT NULL,
            $columnFrequency INTEGER NOT NULL
          )
          ''');
  }

  // Database helper methods:

  Future<int> insert(String tableName, dynamic dataMap) async {
    Database db = await database;
    int id = await db.insert(tableName, dataMap);
    return id;
  }

  Future<dynamic> query(dynamic where, List<String> columns, List<String> whereArgs, String tableName) async {
    Database db = await database;
    List<Map> maps = await db.query(
        // tableWords,
        // columns: [columnId, columnWord, columnFrequency],
        // where: '$columnId = ?',
        // whereArgs: [id]
        tableName,
        columns: columns,
        where: '$where = ?',
        whereArgs: whereArgs
    );
    if (maps.length > 0) {
      // return Word.fromMap(maps.first);
      return maps.first;
    }
    return null;
  }

  // TODO: queryAllWords()
  // TODO: delete(int id)
  // TODO: update(Word word)
}

class DBCreateQueries{
  static const String task = '''
      CREATE TABLE task_table (
        _id INTEGER PRIMARY KEY,
        info TEXT NOT NULL,
        date_time TEXT NOT NULL
        done INTEGER NOT NULL
      )
      ''';
}