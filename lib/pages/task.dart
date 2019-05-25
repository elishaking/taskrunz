import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../scoped-models/main.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import '../utils/responsive.dart';

class TaskPage extends StatefulWidget{
  final TaskGroup taskGroup;
  final int taskIndex;
  final MainModel model;

  TaskPage(this.taskGroup, this.taskIndex, this.model);

  @override
  _TaskPageState createState() => _TaskPageState();
}


String repeatOption = RepeatOptions.days;
bool repeatDateSet = false;
int repeatValue;

class _TaskPageState extends State<TaskPage> {
  Task task;
  DateTime dueDate;
  TimeOfDay dueTime;
  DateTime remindDate;
  TimeOfDay remindTime;

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  

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
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        spreadRadius: 0.7,
                        blurRadius: 1
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
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 3
                      ),
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: remindDate == null ? null : widget.taskGroup.color),
                        title: remindDate == null ? Text("Due Date",) : Text("Due ${dueTime.hour}:${dueDate.minute}", style: TextStyle(color: widget.taskGroup.color)),
                        subtitle: remindTime == null ? null : Text("${months[dueDate.month]} ${dueDate.day}"),
                        onTap: (){
                          showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 360)),
                            initialDate: DateTime.now().add(Duration(hours: 2))
                          ).then((DateTime date){
                            if(date != null){
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 3)
                              ).then((TimeOfDay time){
                                setState(() {
                                 remindDate = date;
                                 remindTime = time; 
                                });
                              });;
                            }
                          });
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.alarm, color: remindDate == null ? null : widget.taskGroup.color),
                        title: remindDate == null ? Text("Remind Date",) : Text("Remind me at ${remindTime.hour}:${remindTime.minute}", style: TextStyle(color: widget.taskGroup.color)),
                        subtitle: remindTime == null ? null : Text("${months[remindDate.month]} ${remindDate.day}"),
                        onTap: (){
                          showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 360)),
                            initialDate: DateTime.now().add(Duration(hours: 2))
                          ).then((DateTime date){
                            if(date != null){
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 3)
                              ).then((TimeOfDay time){
                                setState(() {
                                 dueDate = date;
                                 dueTime = time; 
                                });
                              });;
                            }
                          });
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.repeat, color: repeatValue == null ? null : widget.taskGroup.color,),
                        title: _buildRepeatTitle(),
                        onTap: (){
                          _showRepeatOptionsDialog(context).then((_){
                            setState(() {});
                          });
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

  Text _buildRepeatTitle(){
    if(repeatDateSet){
      return Text(
        repeatValue == 1 ? _singularRepeatText() : "Every $repeatValue $repeatOption", 
        style: TextStyle(color: widget.taskGroup.color,)
      );
    }
    return Text("Repeat");
  }

  String _singularRepeatText(){
    if(repeatOption == RepeatOptions.days) return "Daily";
    else if(repeatOption == RepeatOptions.weeks) return "Weekly";
    else if(repeatOption == RepeatOptions.months) return "Monthly";
    else return "Yearly";
  }

  Future _showRepeatOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: getSize(context, 30), vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                customText.TitleText(text: "Repeat Every", textColor: widget.taskGroup.color,),
                SizedBox(height: 20,),
                RepeatOptionsMenu(),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      textColor: widget.taskGroup.color,
                      onPressed: (){
                        repeatDateSet = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        );
      }
    );
  }
}

class RepeatOptionsMenu extends StatefulWidget {
  @override
  _RepeatOptionsMenuState createState() => _RepeatOptionsMenuState();
}

class _RepeatOptionsMenuState extends State<RepeatOptionsMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (String value){
              repeatValue = int.parse(value);
            },
          ),
        ),
        SizedBox(width: 30,),
        Flexible(
          flex: 4,
          child: DropdownButton<String>(
            value: repeatOption,
            items: [RepeatOptions.days, RepeatOptions.months, RepeatOptions.weeks, RepeatOptions.years].map((String option) => DropdownMenuItem(child: Text(option), value: option,)).toList(),
            onChanged: (String value){
              // print(value);
              setState(() {
                repeatOption = value; 
              });
            },
          ),
        )
      ],
    );
  }
}

class RepeatOptions{
  static final String days = "days";
  static final String weeks = "weeks";
  static final String months = "months";
  static final String years = "years";
}
