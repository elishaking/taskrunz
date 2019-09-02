import 'dart:convert';
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
  Future addTaskGroup(TaskGroup taskGroup) async{
    toggleLoading(true);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap()).toList()));
    await addTaskGroupDB(taskGroup);
    _taskGroups.add(taskGroup);

    toggleLoading(false);
  }

  Future addTask(Task task, TaskGroup taskGroup) async{
    toggleLoading(true);

    taskGroup.tasks.add(task);
    taskGroup.numTask++;
    taskGroup.progressPercent = taskGroup.numTask == 0 ? 0 : (taskGroup.numTasksCompleted / taskGroup.numTask) * 100;

    await updateTaskGroupDB(taskGroup);
    await addTaskDB(task);

    toggleLoading(false);
  }

  Future addTaskStep(Task task, TaskStep taskStep) async{
    toggleLoading(true);

    task.taskSteps.add(taskStep);
    
    await updateTaskDB(task);

    toggleLoading(false);
  }

  Future deleteTask(TaskGroup taskGroup, int index) async{
    toggleLoading(true);

    if(taskGroup.tasks[index].done)
      taskGroup.numTasksCompleted--;
    taskGroup.tasks.removeAt(index);
    taskGroup.numTask--;
    taskGroup.progressPercent = taskGroup.numTask == 0 ? 0 : (taskGroup.numTasksCompleted / taskGroup.numTask) * 100;

    await updateTaskGroupDB(taskGroup);
    await deleteTaskDB(taskGroup.tasks[index]);

    toggleLoading(false);
  }

  Future deleteTaskStep(Task task, int index) async{
    toggleLoading(true);

    task.taskSteps.removeAt(index);

    await updateTaskDB(task);

    toggleLoading(false);
  }

  Future<bool> updateAll(TaskGroup taskGroup, Task task) async{
    await updateTaskGroupDB(taskGroup);
    await updateTaskDB(task);

    return true;
  }

  Future<bool> addTaskGroupDB(TaskGroup taskGroup) async{
    taskGroup.id = await _databaseManager.addTaskGroup(taskGroup);

    return taskGroup.id != -1;
  }

  Future<bool> updateTaskGroupDB(TaskGroup taskGroup) async{
    int count = await _databaseManager.updateTaskGroup(taskGroup);

    return count != 0;
  }

  Future<bool> deleteTaskGroupDB(TaskGroup taskGroup) async{
    int count = await _databaseManager.deleteTaskGroup(taskGroup);

    return count != 0;
  }

  // Future saveTasks() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap()).toList()));
  // }

  Future<bool> addTaskDB(Task task) async{
    task.id = await _databaseManager.addTask(task);

    return task.id != -1;
  }

  Future<bool> updateTaskDB(Task task) async{
    int count = await _databaseManager.updateTask(task);

    return count != 0;
  }

  Future<bool> deleteTaskDB(Task task) async{
    int count = await _databaseManager.deleteTask(task);

    return count != 0;
  }

  Future fetchTasks() async{
    toggleLoading(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.clear();
    String d = pref.getString('taskGroups');
    if(d != null){
      List data = json.decode(d);
      data.forEach((item) {
        _taskGroups.add(TaskGroup.fromMap(item));
      }); 
    }
    toggleLoading(false);
  }
}