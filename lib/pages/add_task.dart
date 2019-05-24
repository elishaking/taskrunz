import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/task.dart';

class AddTask extends StatefulWidget{
  final TaskGroup taskGroup;
  final Map<String, List<Task>> taskWithDates;
  final String today;

  AddTask(this.taskGroup, this.taskWithDates, this.today);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _text;

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
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Task",

                  ),
                  validator: (String value){
                    if(value.isEmpty) return 'Enter a new Task';
                  },
                  onSaved: (String value){
                    _text = value;
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model){
          return FloatingActionButton(
            heroTag: 'add_task',
            child: Icon(Icons.add),
            backgroundColor: widget.taskGroup.color,
            onPressed: (){
              if(_formKey.currentState.validate()){
                _formKey.currentState.save();

                Task newTask = Task(
                  id: widget.taskGroup.tasks.length,
                  info: _text,
                  dateTime: DateTime.now(),
                  done: false
                );

                if(widget.taskWithDates[widget.today] == null){
                  widget.taskWithDates[widget.today] = List<Task>();
                }
                widget.taskWithDates[widget.today].add(newTask);
                
                model.addTask(newTask, widget.taskGroup).then((_){
                  Navigator.of(context).pop();
                });
              }
            },
          );
        },
      ),
    );
  }
}