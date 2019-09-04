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
  static const TASK_GROUP_ID = "taskGroupId";
  static const String INFO = "info";
  static const String TIME_CREATED = "timeCreated";
  static const String TASK_STEPS = "taskSteps";

  static const String TASKGROUP_TABLE = "taskGroupTable";
  static const String ICON = "icon";
  static const String NAME = "name";
  static const String NUM_TASK = "numTask";
  static const String NUM_TASK_COMPLETED = "numTasksCompleted";
  static const String COLOR = "color";
  static const String PROGRESS_PERCENT = "progressPercent";

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
    await createTaskGroupTable(db);
    await createTaskTable(db);
  }

  /// create [TaskGroup] table
  Future<void> createTaskGroupTable(Database db) async{
    final String createTableSql = '''CREATE TABLE $TASKGROUP_TABLE
    (
      $ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $ICON TEXT,
      $NAME TEXT,
      $NUM_TASK INTEGER,
      $NUM_TASK_COMPLETED INTEGER,
      $COLOR TEXT,
      $PROGRESS_PERCENT REAL
    )''';

    await db.execute(createTableSql);
  }

  /// save [TaskGroup] to database and return its [id]
  Future<int> addTaskGroup(TaskGroup taskGroup) async{
    int id = -10;
    try{
      id = await _database.insert(DatabaseManager.TASKGROUP_TABLE, taskGroup.toMap());
    } catch(e){
      if(e.isUniqueConstraintError()) id = -1;
      print("error: $e\id: $id");
    }

    print("inserted: $id");

    return id;
  }

  Future<List<TaskGroup>> getAllTaskGroups() async{
    final sql = '''SELECT * FROM ${DatabaseManager.TASKGROUP_TABLE}''';

    final data = await _database.rawQuery(sql);
    List<TaskGroup> taskGroups = List<TaskGroup>();
    for(final node in data){
      final taskGroup = TaskGroup.fromMap(node);
      taskGroups.add(taskGroup);
    }

    return taskGroups;
  }

  /// get [TaskGroup] from database with [id]
  Future<TaskGroup> getTaskGroup(int id) async{
    final data = await _database.query(DatabaseManager.TASKGROUP_TABLE, where: "${DatabaseManager.ID} == $id");

    return TaskGroup.fromMap(data[0]);
  }

  /// delete [TaskGroup] from database
  Future<int> deleteTaskGroup(TaskGroup taskGroup) async{
    final count = await _database.delete(DatabaseManager.TASKGROUP_TABLE, where: "${DatabaseManager.ID} == ${taskGroup.id}");
    print("deleted: $count");

    return count;
  }

  /// update [TaskGroup] in database
  Future<int> updateTaskGroup(TaskGroup taskGroup) async{
    final count = await _database.update(DatabaseManager.TASKGROUP_TABLE, taskGroup.toMap(), where: "${DatabaseManager.ID} == ${taskGroup.id}");
    print("updated: $count");

    return count;
  }


  /// create [Task] table
  Future<void> createTaskTable(Database db) async{
    final String createTableSql = '''CREATE TABLE $TASK_TABLE
    (
      $ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $INFO CHAR,
      $TIME_CREATED TEXT,
      $TASK_STEPS TEXT
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

  /// get all [Task]s from database with a given [TaskGroup] [id]
  Future<List<Task>> getAllTasksWithTaskGroupId(int taskGroupId) async{
    final data = await _database.query(DatabaseManager.TASK_TABLE, where: "${DatabaseManager.TASK_GROUP_ID} == $taskGroupId", );

    List<Task> tasks = List<Task>();
    for(final node in data){
      final task = Task.fromMap(node);
      tasks.add(task);
    }

    return tasks;
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
  Future<int> deleteTask(Task task) async{
    final sql = '''DELETE FROM ${DatabaseManager.TASK_TABLE} WHERE ${DatabaseManager.ID} == ${task.id}''';

    final count = await _database.rawDelete(sql);
    print("deleted: $count");

    return count;
  }

  /// update [Task] in database
  Future<int> updateTask(Task task) async{
    final count = await _database.update(DatabaseManager.TASK_TABLE, task.toMap(), where: "${DatabaseManager.ID} == ${task.id}");
    print("updated: $count");

    return count;
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
