import 'package:flutter/material.dart';

class TaskGroup{
  int idx;
  IconData icon;
  String name;
  int numTask;
  int numTasksCompleted;
  Color color;
  double progressPercent;
  List<Task> tasks = List<Task>();

  TaskGroup({this.idx, this.icon, this.name, this.numTask, this.progressPercent, this.numTasksCompleted, this.color, this.tasks});

  Map<String, dynamic> toMap(){
    return {
      'idx': idx,
      'icon': [icon.codePoint, icon.fontFamily, icon.fontPackage, icon.matchTextDirection],
      'name': name,
      'numTask': numTask,
      'numTasksCompleted': numTasksCompleted,
      'color': color.value.toString(),
      'progressPercent': progressPercent.toString(),
      'tasks': tasks.length > 0 ? tasks.map((Task task) => task.toMap()).toList() : []
    };
  }

  static TaskGroup fromMap(Map<String, dynamic> item){
    return TaskGroup(
      idx: item['idx'],
      icon: IconData(item['icon'][0], fontFamily: item['icon'][1], fontPackage: item['icon'][2], matchTextDirection: item['icon'][3]),
      name: item['name'],
      numTask: item['numTask'],
      numTasksCompleted: item['numTasksCompleted'],
      color: Color(int.parse(item['color'])),
      progressPercent: double.parse(item['progressPercent']),
      tasks: item['tasks'].map<Task>((task) => Task.fromMap(task)).toList()
    );
  }
}

class Task{
  int id;
  String info;
  DateTime dateTime;
  bool done;

  Task({this.id, this.info, this.dateTime, this.done});

  // Task.fromMap(Map<String, dynamic> map) {
  //   id = map['_id'];
  //   info = map['info'];
  //   dateTime = map['date_time'];
  //   done = map['done'];
  // }

  Map<String, dynamic> toMap() {
    var taskMap = <String, dynamic>{
      'info': info,
      'date_time': dateTime.toIso8601String(),
      'done': done
    };
    if (id != null) {
      taskMap['_id'] = id;
    }
    return taskMap;
  }

  static Task fromMap(Map<String, dynamic> item){
    return Task(
      id: item['_id'],
      info: item['info'],
      dateTime: DateTime.parse(item['date_time']),
      done: item['done']
    );
  }
}

class TaskStep{
  int id;
  String info;
  bool done;

  TaskStep({this.id, this.info, this.done});

  Map<String, dynamic> toMap() {
    var taskStepMap = <String, dynamic>{
      'id': id,
      'info': info,
      'done': done
    };
    if (id != null) {
      taskStepMap['id'] = id;
    }
    return taskStepMap;
  }

  static TaskStep fromMap(Map<String, dynamic> item){
    return TaskStep(
      id: item['id'],
      info: item['info'],
      done: item['done']
    );
  }
}
