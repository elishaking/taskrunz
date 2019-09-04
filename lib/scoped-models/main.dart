import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskrunz/db/db_helper.dart';

import '../models/task.dart';

class MainModel extends Model with ConnectedModel, TaskGroupModel, TaskModel {
  
}

class ConnectedModel extends Model{
  bool _isLoading = false;
  List<TaskGroup> _taskGroups = new List<TaskGroup>();
  String name;
  // [
  //   TaskGroup(
  //     idx: 1,
  //     icon: Icons.work,
  //     name: 'Work',
  //     numTask: 13,
  //     numTasksCompleted: 7,
  //     progressPercent: 7/13 * 100,
  //     color: Colors.blue
  //   ),
  //   TaskGroup(
  //     idx: 2,
  //     icon: Icons.person,
  //     name: 'Personal',
  //     numTask: 10,
  //     numTasksCompleted: 2,
  //     progressPercent: 2/10 * 100,
  //     color: Colors.orange.shade800
  //   ),
  //   TaskGroup(
  //     idx: 3,
  //     icon: Icons.home,
  //     name: 'Home',
  //     numTask: 20,
  //     numTasksCompleted: 9,
  //     progressPercent: 9/20 * 100,
  //     color: Colors.green
  //   ),
  // ];
  // List<Task> _task = List<Task>();

  bool get isLoading{
    return _isLoading;
  }

  List<TaskGroup> get taskGroups{
    return _taskGroups;
  }

  final DatabaseManager _databaseManager = DatabaseManager();
  
  // ConnectedModel(){
  //   _databaseManager = DatabaseManager();
  // }

  void toggleLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> getName() async{
    toggleLoading(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");

    toggleLoading(false);

    return name != null;
  }

  Future<bool> saveName(String newName) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = newName;

    return await pref.setString("name", newName);
  }
}

class TaskGroupModel extends ConnectedModel{
  
}

class TaskModel extends ConnectedModel{

  /// gets all [taskGroups] from the database with all their corresponding [tasks]
  Future<void> getAllTaskGroupsDB() async{
    _taskGroups = await _databaseManager.getAllTaskGroups();
    _taskGroups.forEach(await (TaskGroup taskGroup) async {
      taskGroup.tasks = await _databaseManager.getAllTasksWithTaskGroupId(taskGroup.id);
    });
  }

  /// adds a new [TaskGroup] to the database and the [List] of [TaskGroup] objects already in memory
  Future addTaskGroup(TaskGroup taskGroup) async{
    toggleLoading(true);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap()).toList()));
    await _addTaskGroupDB(taskGroup);
    _taskGroups.add(taskGroup);

    toggleLoading(false);
  }

  /// adds a new [Task] to the database and the corresponding [TaskGroup] object already in memory
  Future addTask(Task task, TaskGroup taskGroup) async{
    toggleLoading(true);

    taskGroup.tasks.add(task);
    taskGroup.numTask++;
    taskGroup.progressPercent = taskGroup.numTask == 0 ? 0 : (taskGroup.numTasksCompleted / taskGroup.numTask) * 100;

    await _updateTaskGroupDB(taskGroup);
    await _addTaskDB(task);

    toggleLoading(false);
  }

  /// adds a new [TaskStep] to the database and the corresponding [Task] object already in memory
  Future addTaskStep(Task task, TaskStep taskStep) async{
    toggleLoading(true);

    task.taskSteps.add(taskStep);
    task.done = false;
    
    await _updateTaskDB(task);

    toggleLoading(false);
  }

  /// deletes a [Task] from the database and the corresponding [TaskGroup] object already in memory
  Future deleteTask(TaskGroup taskGroup, int index) async{
    toggleLoading(true);

    if(taskGroup.tasks[index].done)
      taskGroup.numTasksCompleted--;
    taskGroup.tasks.removeAt(index);
    taskGroup.numTask--;
    taskGroup.progressPercent = taskGroup.numTask == 0 ? 0 : (taskGroup.numTasksCompleted / taskGroup.numTask) * 100;

    await _updateTaskGroupDB(taskGroup);
    await _deleteTaskDB(taskGroup.tasks[index]);

    toggleLoading(false);
  }

  /// deletes a [TaskStep] from the database and the corresponding [Task] object already in memory
  Future deleteTaskStep(Task task, int index) async{
    toggleLoading(true);

    task.taskSteps.removeAt(index);

    await _updateTaskDB(task);

    toggleLoading(false);
  }

  /// updates all contents of the database including [TaskGroups] and [Tasks]
  Future<bool> updateAll(TaskGroup taskGroup, Task task) async{
    await _updateTaskGroupDB(taskGroup);
    await _updateTaskDB(task);

    return true;
  }

  Future<bool> _addTaskGroupDB(TaskGroup taskGroup) async{
    taskGroup.id = await _databaseManager.addTaskGroup(taskGroup);

    return taskGroup.id != -1;
  }

  Future<bool> _updateTaskGroupDB(TaskGroup taskGroup) async{
    int count = await _databaseManager.updateTaskGroup(taskGroup);

    return count != 0;
  }

  Future<bool> _deleteTaskGroupDB(TaskGroup taskGroup) async{
    int count = await _databaseManager.deleteTaskGroup(taskGroup);

    return count != 0;
  }

  // Future saveTasks() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap()).toList()));
  // }

  Future<bool> _addTaskDB(Task task) async{
    task.id = await _databaseManager.addTask(task);

    return task.id != -1;
  }

  Future<bool> _updateTaskDB(Task task) async{
    int count = await _databaseManager.updateTask(task);

    return count != 0;
  }

  Future<List<Task>> _getAllTasksDB(int taskGroupId) async{
    return await _databaseManager.getAllTasksWithTaskGroupId(taskGroupId);
  }

  Future<bool> _deleteTaskDB(Task task) async{
    int count = await _databaseManager.deleteTask(task);

    return count != 0;
  }

  // Future fetchTasks() async{
  //   toggleLoading(true);

  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   // pref.clear();
  //   String d = pref.getString('taskGroups');
  //   if(d != null){
  //     List data = json.decode(d);
  //     data.forEach((item) {
  //       _taskGroups.add(TaskGroup.fromMap(item));
  //     }); 
  //   }
  //   toggleLoading(false);
  // }
}