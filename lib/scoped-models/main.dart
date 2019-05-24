import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class MainModel extends Model with ConnectedModel, TaskGroupModel, TaskModel {}

class ConnectedModel extends Model{
  bool _isLoading = false;
  List<TaskGroup> _taskGroups = new List<TaskGroup>();
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

  void toggleLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
}

class TaskGroupModel extends ConnectedModel{
  Future addTaskGroup(TaskGroup taskGroup) async{
    toggleLoading(true);

    _taskGroups.add(taskGroup);

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap()).toList()));

    toggleLoading(false);
  }
}

class TaskModel extends ConnectedModel{
  Future addTask(Task task, TaskGroup taskGroup) async{
    toggleLoading(true);

    taskGroup.tasks.add(task);
    taskGroup.numTask++;
    taskGroup.progressPercent = (taskGroup.numTask / taskGroup.numTasksCompleted) * 100;

    await saveTasks();

    toggleLoading(false);
  }

  Future saveTasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap()).toList()));
  }

  Future deleteTask(TaskGroup taskGroup, int index) async{
    toggleLoading(true);

    if(taskGroup.tasks[index].done)
      taskGroup.numTasksCompleted--;
    taskGroup.tasks.removeAt(index);
    taskGroup.numTask--;
    taskGroup.progressPercent = taskGroup.numTasksCompleted == 0 ? 0 : (taskGroup.numTask / taskGroup.numTasksCompleted) * 100;

    await saveTasks();

    toggleLoading(false);
  }

  Future fetchTasks() async{
    toggleLoading(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
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