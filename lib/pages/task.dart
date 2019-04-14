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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'name',
              child: customText.HeadlineText(text: widget.taskGroup.name,),
            )
          ],
        ),
      ),
    );
  }
}
