import 'package:flutter/material.dart';

import '../models/task.dart';

class AddTask extends StatefulWidget{
  final TaskGroup taskGroup;

  AddTask(this.taskGroup);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('New Task', style: TextStyle(color: widget.taskGroup.color),),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: widget.taskGroup.color
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Task",

                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_task',
        child: Icon(Icons.add),
        onPressed: (){

        },
      ),
    );
  }
}