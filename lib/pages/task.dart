import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import './add_task.dart';

class TaskPage extends StatefulWidget{
  final TaskGroup taskGroup;
  final MainModel model;

  TaskPage(this.taskGroup, this.model);

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage>{
  double _targetWidth = 0;

  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    final double proressIndicatorWidth = _getSize(380);
    final double progressFraction = (widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask);
    final double progressPercent = progressFraction * 100;
    final double progress = widget.taskGroup.numTasksCompleted == 0 ? 0 : (progressFraction * proressIndicatorWidth).roundToDouble();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: widget.taskGroup.color
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: widget.taskGroup.color,),
        //   onPressed: (){
        //     Navigator.of(context).pop();
        //   },
        // ),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Hero(
            //   tag: 'icon' + widget.taskGroup.idx.toString(),
            //   child: 
              Icon(widget.taskGroup.icon, color: widget.taskGroup.color,),
            // ),
            SizedBox(height: 20,),
            customText.BodyText(text: '${widget.taskGroup.numTask} Tasks', textColor: Colors.grey,),
            SizedBox(height: 3,),
            customText.HeadlineText(text: widget.taskGroup.name, textColor: Colors.black,),
            SizedBox(height: 20,),
              // Hero(
              //   tag: 'progress' + widget.taskGroup.idx.toString(),
              //   child: 
                Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 3, width: proressIndicatorWidth, color: widget.taskGroup.color.withOpacity(0.3),),
                        Container(height: 3, width: progress, color: widget.taskGroup.color,),
                      ],
                    ),
                    SizedBox(width: 7,),
                    customText.TinyText(text: '${progressPercent.toStringAsFixed(1)} %', textColor: widget.taskGroup.color,)
                  ],
                ),
              // )
            SizedBox(height: 20,),
            // customText.BodyText(text: 'TODAY', textColor: Colors.grey,),
            // SizedBox(height: 20,),
            Container(
              // padding: const EdgeInsets.all(8.0),
              height: MediaQuery.of(context).size.height,
              child: ReorderableListView(
                children: List.generate(widget.taskGroup.tasks.length, (int index){
                  return buildTask(widget.taskGroup.tasks[index]);
                }),
                onReorder: (int prevPos, int newPos){
                  print("$prevPos $newPos");
                  Task movedTask = widget.taskGroup.tasks[prevPos];
                  setState(() {
                   widget.taskGroup.tasks.removeAt(prevPos);
                   widget.taskGroup.tasks.insert(newPos, movedTask); 
                  });
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_task',
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddTask(widget.taskGroup)
          ));
        },
        backgroundColor: widget.taskGroup.color,
      ),
    );
  }

  ListTile buildTask(Task task) {
    return ListTile(
      key: UniqueKey(),
      contentPadding: EdgeInsets.only(left: 0),
      leading: Checkbox(
        value: task.done,
        activeColor: widget.taskGroup.color,
        onChanged: (bool value){
          setState(() {
           task.done = value; 
          });
        },
      ),
      title: Text(task.info),
      trailing: customText.TinyText(text: isToday(task.dateTime) ? "Today" : "${months[task.dateTime.month]} ${task.dateTime.day}", textColor: Colors.black,),
      onTap: (){

      },
    );
  }

  bool isDay(DateTime dateTime, int day, int month){
    return dateTime.day == day && dateTime.month == month;
  }

  bool isToday(DateTime dateTime){
    DateTime now = DateTime.now();
    return dateTime.day == now.day && dateTime.month == now.month;
  }
}
