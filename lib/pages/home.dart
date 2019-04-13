import 'package:flutter/material.dart';

import '../models/task.dart';

class HomePage extends StatelessWidget{
  final List<TaskGroup> _taskGroups = [
    TaskGroup(
      icon: Icon(Icons.work),
      name: 'Work',
      numTask: '13',
      numTasksCompleted: '7'
    ),
    TaskGroup(
      icon: Icon(Icons.person),
      name: 'Personal',
      numTask: '10',
      numTasksCompleted: '2'
    ),
    TaskGroup(
      icon: Icon(Icons.home),
      name: 'Home',
      numTask: '20',
      numTasksCompleted: '9'
    ),
  ];

  Widget _buildTaskGroup(TaskGroup taskGroup){
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            taskGroup.icon,
            SizedBox(height: 30,),
            Text('${taskGroup.numTask} Tasks'),
            SizedBox(height: 10,),
            Text('${taskGroup.name}'),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('GOALZZ'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              child: Image(
                image: AssetImage('assets/passport.png'),
              ),
            ),
            SizedBox(height: 20,),
            Text('Hello King'),
            SizedBox(height: 10,),
            Text("Let's get cracking"),
            SizedBox(height: 5,),
            Text("You have 3 tasks today"),
            SizedBox(height: 10,),
            Text("TODAY, APRIL 10, 2018"),
            SizedBox(height: 30,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_taskGroups.length, (int index) => _buildTaskGroup(_taskGroups[index])),
              ),
            )
          ],
        ),
      ),
    );
  }
}