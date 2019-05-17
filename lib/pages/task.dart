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

  @override
  void initState() {
    widget.model.fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    final double proressIndicatorWidth = _getSize(400);
    final double progress = ((widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask) * proressIndicatorWidth).roundToDouble();
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
          children: <Widget>[
            Hero(
              tag: 'icon' + widget.taskGroup.idx.toString(),
              child: Icon(widget.taskGroup.icon, color: widget.taskGroup.color,),
            ),
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
                    customText.TinyText(text: '${widget.taskGroup.progressPercent.toStringAsPrecision(2)} %', textColor: widget.taskGroup.color,)
                  ],
                ),
              // )
            SizedBox(height: 20,),
            customText.BodyText(text: 'TODAY', textColor: Colors.grey,),
            SizedBox(height: 20,),
            
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
}
