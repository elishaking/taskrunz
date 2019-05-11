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
      'icon': icon.codePoint.toString(),
      'name': name,
      'numTask': numTask,
      'numTasksCompleted': numTasksCompleted,
      'color': color.value.toString(),
      'progressPercent': progressPercent.toString(),
      'tasks': tasks.map((Task task) => task.toMap()).toList()
    };
  }

  static TaskGroup fromMap(Map<String, dynamic> item){
    return TaskGroup(
      idx: item['idx'],
      icon: IconData(item[int.parse(item['icon'])]),
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