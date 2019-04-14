import 'package:flutter/material.dart';

class TaskGroup{
  final IconData icon;
  final String name;
  final String numTask;
  final String numTasksCompleted;
  final Color color;

  TaskGroup({this.icon, this.name, this.numTask, this.numTasksCompleted, this.color});
}