import 'package:flutter/material.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

class TaskPage extends StatefulWidget{
  final TaskGroup taskGroup;

  TaskPage(this.taskGroup);

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage>{
  @override
  Widget build(BuildContext context) {
    final double proressIndicatorWidth = 230;
    final double progress = ((double.parse(widget.taskGroup.numTasksCompleted) / double.parse(widget.taskGroup.numTask)) * proressIndicatorWidth).roundToDouble();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
            SizedBox(height: 10,),
            customText.HeadlineText(text: widget.taskGroup.name, textColor: Colors.black,),
            SizedBox(height: 15,),
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
                    customText.TinyText(text: '${progress.toInt().toString()} %', textColor: widget.taskGroup.color,)
                  ],
                ),
              // )
          ],
        ),
      ),
    );
  }
}
