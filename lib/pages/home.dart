import 'package:flutter/material.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import './task.dart';

class HomePage extends StatelessWidget{
  final List<TaskGroup> _taskGroups = [
    TaskGroup(
      icon: Icons.work,
      name: 'Work',
      numTask: '13',
      numTasksCompleted: '7',
      color: Colors.blue
    ),
    TaskGroup(
      icon: Icons.person,
      name: 'Personal',
      numTask: '10',
      numTasksCompleted: '2',
      color: Colors.orange
    ),
    TaskGroup(
      icon: Icons.home,
      name: 'Home',
      numTask: '20',
      numTasksCompleted: '9',
      color: Colors.green
    ),
  ];

  Widget _buildTaskGroup(BuildContext context, TaskGroup taskGroup){
    final double proressIndicatorWidth = 120;
    final double progress = ((double.parse(taskGroup.numTasksCompleted) / double.parse(taskGroup.numTask)) * proressIndicatorWidth).roundToDouble();
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => TaskPage(taskGroup)
        ));
      },
      child: Container(
        width: 200,
        height: 200,
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.only(right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(taskGroup.icon, color: taskGroup.color,),
                Expanded(child: Container(),),
                customText.TinyText(text: '${taskGroup.numTask} Tasks', textColor: Colors.grey,),
                SizedBox(height: 10,),
                customText.TitleText(text: '${taskGroup.name}', textColor: Colors.black,),
                SizedBox(height: 15,),
                Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 3, width: proressIndicatorWidth, color: taskGroup.color.withOpacity(0.3),),
                        Container(height: 3, width: progress, color: taskGroup.color,),
                      ],
                    ),
                    SizedBox(width: 7,),
                    customText.TinyText(text: '${progress.toInt().toString()} %', textColor: taskGroup.color,)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('GOALZZ'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image(
                  image: AssetImage('assets/passport.png'),
                ),
              ),
            ),
            SizedBox(height: 20,),
            customText.HeadlineText(
              text: 'Hello King',
            ),
            SizedBox(height: 10,),
            customText.BodyText(
              text: "Let's get cracking"
            ),
            SizedBox(height: 5,),
            customText.BodyText(text: "You have 3 tasks today"),
            SizedBox(height: 30,),
            customText.BodyText(text: "TODAY, APRIL 10, 2018", fontWeight: FontWeight.bold,),
            SizedBox(height: 5,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_taskGroups.length, (int index) => _buildTaskGroup(context, _taskGroups[index])),
              ),
            )
          ],
        ),
      ),
    );
  }
}