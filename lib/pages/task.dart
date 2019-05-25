import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        backgroundColor: Colors.white,
        title: customText.BodyText(text: '',),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        color: Colors.white,
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model){
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1.7),
                        spreadRadius: 0.3,
                        // blurRadius: 1
                      ),
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
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
                        title: customText.HeadlineText(text: task.info, textColor: widget.taskGroup.color,),
                      ),
                      SizedBox(height: 5,),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add, color: widget.taskGroup.color,),
                            SizedBox(width: 10,),
                            customText.BodyText(text: "Add Step", textColor: widget.taskGroup.color,)
                          ],
                        ),
                        onPressed: (){
                          
                        },
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 0),
                        spreadRadius: 1.7,
                        // blurRadius: 1
                      ),
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: customText.BodyText(text: "Due Date", 
                        textColor: Colors.grey,),
                        onTap: (){

                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.alarm),
                        title: customText.BodyText(text: "Remind  me", 
                        textColor: Colors.grey,),
                        onTap: (){
                          
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.repeat),
                        title: customText.BodyText(text: "Repeat", 
                        textColor: Colors.grey,),
                        onTap: (){
                          
                        },
                      ),
                      // Divider(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}