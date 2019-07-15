// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// import '../models/task.dart';

// // database table and column names
// final String tasksTable = 'tasks';
// final String columnId = '_id';
// final String columnInfo = 'info';
// final String columnDateTime = 'date_time';
// final String columnDone = 'done';

// // singleton class to manage the database
// class DatabaseHelper {

//   // This is the actual database filename that is saved in the docs directory.
//   static final _databaseName = "Goalzz.db";
//   // Increment this version when you need to change the schema.
//   static final _databaseVersion = 1;

//   // Make this a singleton class.
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // Only allow a single open connection to the database.
//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _initDatabase();
//     return _database;
//   }

//   // open the database
//   _initDatabase() async {
//     // The path_provider plugin gets the right directory for Android or iOS.
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     // Open the database. Can also add an onUpdate callback parameter.
//     return await openDatabase(path,
//         version: _databaseVersion,
//         onCreate: _onCreate);
//   }

//   // SQL string to create the database 
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $tasksTable (
//             $columnId INTEGER PRIMARY KEY,
//             $columnInfo TEXT NOT NULL,
//             $columnDateTime TEXT NOT NULL,
//             $columnDone INTEGER NOT NULL
//           )
//           ''');
//   }

//   // Database helper methods:

//   Future<int> insert(Task task) async {
//     Database db = await database;
//     int id = await db.insert(tasksTable, task.toMap());
//     return id;
//   }

//   Future<Task> queryWhereId(int id) async {
//     Database db = await database;
//     List<Map> maps = await db.query(tasksTable,
//         columns: [columnId, columnInfo, columnDateTime, columnDone],
//         where: '$columnId = ?',
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       // return Task.fromMap(maps.first);
//       dynamic taskMap = maps.first;
//       return Task(
//         id: taskMap['_id'],
//         info: taskMap['info'],
//         dateTime: taskMap['date_time'],
//         done: taskMap['done']
//       );
//     }
//     return null;
//   }

//   read() async {
//     DatabaseHelper helper = DatabaseHelper.instance;
//     int rowId = 1;
//     Task task = await helper.queryWhereId(rowId);
//     if (task == null) {
//       print('read row $rowId: empty');
//     } else {
//       print('read row $rowId: ${task.info}');
//     }
//   }

//   save(Task task) async {
//     DatabaseHelper helper = DatabaseHelper.instance;
//     int id = await helper.insert(task);
//     print('inserted row: $id');
//   }

//   // TODO: queryAllWords()
//   // TODO: delete(int id)
//   // TODO: update(Task task)
// }