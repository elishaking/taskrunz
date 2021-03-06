import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskrunz/models/task.dart';
import 'package:taskrunz/scoped-models/main.dart';

class AddTaskStep extends StatefulWidget {
  final TaskGroup taskGroup;
  final int taskIndex;


  AddTaskStep(this.taskGroup, this.taskIndex);

  @override
  _AddTaskStepState createState() => _AddTaskStepState();
}

class _AddTaskStepState extends State<AddTaskStep> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    labelText: "Task Step",

                  ),
                  validator: (String value){
                    if(value.isEmpty) return 'Enter Task step';
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
            // heroTag: 'add_task_step',
            child: Icon(Icons.add),
            backgroundColor: widget.taskGroup.color,
            onPressed: (){
              if(_formKey.currentState.validate()){
                _formKey.currentState.save();
                
                model.addTaskStep(widget.taskGroup.tasks[widget.taskIndex], TaskStep(
                  info: _text,
                  done: false
                )).then((_){
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