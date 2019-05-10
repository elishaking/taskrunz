import 'package:flutter/material.dart';

class TaskGroup{
  final int idx;
  final IconData icon;
  final String name;
  final String numTask;
  final String numTasksCompleted;
  final Color color;
  final double progressPercent;

  TaskGroup({this.idx, this.icon, this.name, this.numTask, this.progressPercent, this.numTasksCompleted, this.color});
}

class Task{
  final int id;
  final String info;
  final DateTime dateTime;
  final bool done;

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
      'date_time': dateTime,
      'done': done
    };
    if (id != null) {
      taskMap['_id'] = id;
    }
    return taskMap;
  }
}