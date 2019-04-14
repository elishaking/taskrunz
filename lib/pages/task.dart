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
  double _targetWidth = 0;

  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    final double proressIndicatorWidth = _getSize(410);
    final double progress = ((double.parse(widget.taskGroup.numTasksCompleted) / double.parse(widget.taskGroup.numTask)) * proressIndicatorWidth).roundToDouble();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: widget.taskGroup.color,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),

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
                    customText.TinyText(text: '${progress.toInt().toString()} %', textColor: widget.taskGroup.color,)
                  ],
                ),
              // )
            SizedBox(height: 20,),
            customText.BodyText(text: 'TODAY', textColor: Colors.grey,),
            SizedBox(height: 20,),
            Column(
              // children: List.generate(length, generator),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          
        },
        backgroundColor: widget.taskGroup.color,
      ),
    );
  }
}
