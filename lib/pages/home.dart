import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import './task.dart';
import './new_task_group.dart';

class HomePage extends StatefulWidget{
  final MainModel model;

  HomePage(this.model);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskGroup> _taskGroups = new List<TaskGroup>();
  // [
  //   TaskGroup(
  //     idx: 1,
  //     icon: Icons.work,
  //     name: 'Work',
  //     numTask: 13,
  //     numTasksCompleted: 7,
  //     progressPercent: 7/13 * 100,
  //     color: Colors.blue
  //   ),
  //   TaskGroup(
  //     idx: 2,
  //     icon: Icons.person,
  //     name: 'Personal',
  //     numTask: 10,
  //     numTasksCompleted: 2,
  //     progressPercent: 2/10 * 100,
  //     color: Colors.orange.shade800
  //   ),
  //   TaskGroup(
  //     idx: 3,
  //     icon: Icons.home,
  //     name: 'Home',
  //     numTask: 20,
  //     numTasksCompleted: 9,
  //     progressPercent: 9/20 * 100,
  //     color: Colors.green
  //   ),
  // ];

  @override
  initState(){
    widget.model.fetchTasks().then((_){
      _taskGroups = widget.model.taskGroups;
    });
    super.initState();
  }

  double _targetWidth = 0;

  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  Widget _buildTaskGroup(BuildContext context, TaskGroup taskGroup){
    final double proressIndicatorWidth = _getSize(230);
    final double progress = taskGroup.numTasksCompleted == 0 ? 0 : ((taskGroup.numTasksCompleted / taskGroup.numTask) * proressIndicatorWidth).roundToDouble();
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => TaskPage(taskGroup, MediaQuery.of(context).size.width, widget.model)
        ));
      },
      child: Container(
        width: _getSize(350),
        height: _getSize(400),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: EdgeInsets.only(right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Hero(
                //   tag: 'icon' + taskGroup.idx.toString(),
                //   child: 
                  Icon(taskGroup.icon, color: taskGroup.color,),
                // ),
                Expanded(child: Container(),),
                customText.TinyText(text: '${taskGroup.numTask} Tasks', textColor: Colors.grey,),
                SizedBox(height: 10,),
                customText.TitleText(text: '${taskGroup.name}', textColor: Colors.black,),
                SizedBox(height: _getSize(20),),
                // Hero(
                //   tag: 'progress' + taskGroup.idx.toString(),
                //     child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 3, width: proressIndicatorWidth, color: taskGroup.color.withOpacity(0.3),),
                          Container(height: 3, width: progress, color: taskGroup.color,),
                        ],
                      ),
                      customText.TinyText(text: '${progress.toStringAsFixed(1)} %', textColor: taskGroup.color,)
                    ],
                  ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.orange.shade800,
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('GOALZZ'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade800,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _getSize(20),),
            CircleAvatar(
              // backgroundColor: Colors.white,
              radius: 40,
              backgroundImage: AssetImage('assets/passport.png'),
            ),
            SizedBox(height: _getSize(30),),
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
            SizedBox(height: 10),
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model){
                return _buildTaskGroups(context, model);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NewTaskGroupPage(_taskGroups)
          ));
        },
      ),
    );
  }

  Widget _buildTaskGroups(BuildContext context, MainModel model) {
    if(model.isLoading){
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if(model.taskGroups.length == 0) {
      return Expanded(
        child: Center(
          child: Icon(Icons.not_listed_location, size: 100, color: Colors.white,),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_taskGroups.length, (int index) => _buildTaskGroup(context, _taskGroups[index])),
        ),
      );
    }
  }
}