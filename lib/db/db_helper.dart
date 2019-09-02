import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:taskrunz/models/task.dart';

// Database db;

class DatabaseManager {
  static Database _database;
  static String DB_NAME = "todo.db";


  static const TASK_TABLE = "taskTable";
  static const ID = "id";
  static const String INFO = "info";
  static const String TIME_CREATED = "timeCreated";
  static const String TASK_STEPS = "taskSteps";

  DatabaseManager() {
    if(_database == null) initDatabase().then((Database db) => _database = db);
  }

  Database get database {
    return _database;
  }

  Future<Database> initDatabase() async{
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);

    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async{
    await createTaskTable(db);
  }

  /// create [Task] table
  Future<void> createTaskTable(Database db) async{
    final String createTableSql = '''CREATE TABLE $TASK_TABLE
    (
      $ID CHAR PRIMARY KEY,
      $INFO CHAR,
      $TIME_CREATED TEXT,
      $TASK_STEPS TEXT,
    )''';

    await db.execute(createTableSql);
  }

  /// get all [Task]s from database
  Future<List<Task>> getAllTasks() async{
    final sql = '''SELECT * FROM ${DatabaseManager.TASK_TABLE}''';

    final data = await _database.rawQuery(sql);
    List<Task> tasks = List<Task>();
    for(final node in data){
      final task = Task.fromMap(node);
      tasks.add(task);
    }

    return tasks;
  }

  /// get [Task] from database with [id]
  Future<Task> getTask(int id) async{
    final data = await _database.query(DatabaseManager.TASK_TABLE, where: "${DatabaseManager.ID} == $id");

    return Task.fromMap(data[0]);
  }

  /// get [Task] from database with [timeCreated]
  Future<Task> getTaskWithDate(DateTime dateTime) async{
    final data = await _database.query(DatabaseManager.TASK_TABLE, where: "${DatabaseManager.TIME_CREATED} == ${formatDateTime(dateTime)}");

    return Task.fromMap(data[0]);
  }

  /// save [Task] to database and return its [id]
  Future<int> addTask(Task task) async{
    int id = -10;
    try{
      id = await _database.insert(DatabaseManager.TASK_TABLE, task.toMap());
    } catch(e){
      if(e.isUniqueConstraintError()) id = -1;
      print("error: $e\id: $id");
    }

    print("inserted: $id");

    return id;
  }

  /// delete [Task] from database
  Future<void> deleteTask(Task task) async{
    final sql = '''DELETE FROM ${DatabaseManager.TASK_TABLE} WHERE ${DatabaseManager.ID} == ${task.id}''';

    final result = await _database.rawDelete(sql);
    print("deleted: $result");
  }

  /// update [Task] in database
  Future<void> updateTask(Task task) async{
    final result = await _database.update(DatabaseManager.TASK_TABLE, task.toMap(), where: "${DatabaseManager.ID} == ${task.id}");
    print("updated: $result");
  }

  Future<int> tasksCount() async{
    final data = await _database.rawQuery('''SELECT COUNT(*) FROM ${DatabaseManager.TASK_TABLE}''');

    print("count: " + jsonEncode(data[0]));
    return data[0].values.elementAt(0);
  }

  Future<void> closeDb() async {
    _database.close();
  }
  // Future<String> getDatabasePath(String dbName) async {
  //   final String databasePath = await getDatabasesPath();
  //   final String path = join(databasePath, dbName);

  //   if(await Directory(path).exists()){
  //     await deleteDatabase(path);
  //   } else {
  //     await Directory(path).create(recursive: true);
  //   }

  //   return path;
  // }

}

// utitities
