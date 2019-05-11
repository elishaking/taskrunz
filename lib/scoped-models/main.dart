import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class MainModel extends Model with ConnectedModel, TaskModel {}

class ConnectedModel extends Model{
  bool _isLoading = false;
  List<TaskGroup> _taskGroups = List<TaskGroup>();
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

class TaskModel extends ConnectedModel{
  void addTask(Task task, int taskGroupIdx) async{
    toggleLoading(true);

    TaskGroup taskGroup = _taskGroups[taskGroupIdx];
    taskGroup.tasks.add(task);
    taskGroup.numTask++;
    taskGroup.progressPercent = (taskGroup.numTask / taskGroup.numTasksCompleted) * 100;

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('taskGroups', json.encode(_taskGroups.map((TaskGroup taskGroup) => taskGroup.toMap())));

    toggleLoading(false);
  }
}