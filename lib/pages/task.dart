import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

class TaskPage extends StatefulWidget{
  final TaskGroup taskGroup;
  final int taskIndex;
  final MainModel model;

  TaskPage(this.taskGroup, this.taskIndex, this.model);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Task task;

  @override
  void initState() {
    task = widget.taskGroup.tasks[widget.taskIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: customText.BodyText(text: '',),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model){
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Checkbox(
                    value: task.done,
                    onChanged: (bool value){
                      setState(() {
                        task.done = value; 
                      });
                      value ? widget.taskGroup.numTasksCompleted++ : widget.taskGroup.numTasksCompleted--;
                      widget.taskGroup.progressPercent = (widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask) * 100;
                      widget.model.saveTasks();
                    },
                  ),
                  title: customText.TitleText(text: task.info, textColor: widget.taskGroup.color,),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}