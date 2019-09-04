import 'dart:convert';

import 'package:flutter/material.dart';

/// Class for a new [taskGroup] - saved in a table
class TaskGroup{
  int id;
  IconData icon;
  String name;
  int numTask;
  int numTasksCompleted;
  Color color;
  double progressPercent;
  List<Task> tasks = List<Task>();

  TaskGroup({this.id, this.icon, this.name, this.numTask, this.progressPercent, this.numTasksCompleted, this.color});

  Map<String, dynamic> toMap(){
    return {
      // 'id': id,
      'icon': jsonEncode([icon.codePoint, icon.fontFamily, icon.fontPackage, icon.matchTextDirection]),
      'name': name,
      'numTask': numTask,
      'numTasksCompleted': numTasksCompleted,
      'color': color.value.toString(),
      'progressPercent': progressPercent,
      // 'tasks': tasks.length > 0 ? tasks.map((Task task) => task.toMap()).toList() : []
    };
  }

  static TaskGroup fromMap(Map<String, dynamic> item){
    final icon = jsonDecode(item['icon']);
    return TaskGroup(
      id: item['id'],
      icon: IconData(icon[0], fontFamily: icon[1], fontPackage: icon[2], matchTextDirection: icon[3]),
      name: item['name'],
      numTask: item['numTask'],
      numTasksCompleted: item['numTasksCompleted'],
      color: Color(int.parse(item['color'])),
      progressPercent: item['progressPercent'],
      // tasks: item['tasks'].map<Task>((task) => Task.fromMap(task)).toList()
    );
  }
}

/// Class for a new [task] - saved in a table
class Task{
  int id;
  int taskGroupId;
  String info;
  DateTime timeCreated;
  bool done;
  List<TaskStep> taskSteps;

  Task({this.id, this.taskGroupId, this.info, this.timeCreated, this.done, this.taskSteps});

  // Task.fromMap(Map<String, dynamic> map) {
  //   id = map['_id'];
  //   info = map['info'];
  //   dateTime = map['date_time'];
  //   done = map['done'];
  // }

  Map<String, dynamic> toMap() {
    var taskMap = <String, dynamic>{
      'taskGroupId': taskGroupId,
      'info': info,
      'timeCreated': formatDateTime(timeCreated),
      'done': done ? 1 : 0,
      'taskSteps': jsonEncode(taskSteps == null ? List<TaskStep>() : taskSteps.map((TaskStep taskStep) => taskStep.toMap()).toList())
    };
    // if (id != null) {
    //   taskMap['id'] = id;
    // }
    return taskMap;
  }

  static Task fromMap(Map<String, dynamic> item){
    List<String> dateVals = item["timeCreated"].split("+");
    return Task(
      id: item['id'],
      info: item['info'],
      timeCreated: DateTime(int.parse(dateVals[0]), int.parse(dateVals[1]), int.parse(dateVals[2]), 0, 30),
      done: item['done'] == 1 ? true : false,
      taskSteps: jsonDecode(item['taskSteps']).map<TaskStep>((taskStep) => TaskStep.fromMap(taskStep)).toList()
    );
  }
}

/// Class for a new taskStep - saved as a string in the [Task] table
class TaskStep{
  int id;
  String info;
  bool done;

  TaskStep({this.id, this.info, this.done});

  Map<String, dynamic> toMap() {
    var taskStepMap = <String, dynamic>{
      // 'id': id,
      'info': info,
      'done': done
    };
    // if (id != null) {
    //   taskStepMap['id'] = id;
    // }
    return taskStepMap;
  }

  static TaskStep fromMap(Map<String, dynamic> item){
    return TaskStep(
      id: item['id'],
      info: item['info'],
      done: item['done'] == 1 ? true : false,
    );
  }
}

String formatDateTime(DateTime dateTime){
  return "${dateTime.year}+${dateTime.month}+${dateTime.day}";
}
