import 'package:flutter/material.dart';
import 'package:taskrunz/models/task.dart';

class AddTaskStep extends StatelessWidget {
  final TaskGroup taskGroup;

  AddTaskStep(this.taskGroup);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: taskGroup.color
        ),
      ),
    );
  }
}