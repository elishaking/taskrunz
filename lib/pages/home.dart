import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import '../utils/responsive.dart';

import './tasks.dart';
import './add_task_group.dart';

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

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  ScrollController taskGroupScrollController = ScrollController(keepScrollOffset: true);

  @override
  initState(){
    // widget.model.fetchTasks().then((_){
    //   _taskGroups = widget.model.taskGroups;
    // });
    widget.model.getAllTaskGroupsDB().then((_){
      setState(() {
       _taskGroups = widget.model.taskGroups; 
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.orange.shade800,
      // drawer: Drawer(),
      // appBar: AppBar(
      //   // title: customText.HeadlineText(text: "TaskRunz",),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: getSize(context, 20),),
            // CircleAvatar(
            //   // backgroundColor: Colors.white,
            //   radius: 40,
            //   backgroundImage: AssetImage('assets/passport.png'),
            // ),
            Icon(Icons.schedule, size: getSize(context, 100), color: Colors.white,),
            SizedBox(height: getSize(context, 20),),
            customText.HeadlineText(
              text: 'Hello ${widget.model.name}',
            ),
            SizedBox(height: 10,),
            customText.BodyText(
              text: "Let's get cracking"
            ),
            // SizedBox(height: 5,),
            // customText.BodyText(text: "You have 3 tasks today"),
            SizedBox(height: getSize(context, 30),),
            customText.BodyText(text: "${months[_date.month - 1].toUpperCase()} ${_date.day}, ${_date.year}", fontWeight: FontWeight.bold,),
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
          double previousOffset = 0;
          if(taskGroupScrollController.hasClients)
            previousOffset = taskGroupScrollController.offset;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddTaskGroupPage(_taskGroups)
          )).then((onValue){
            WidgetsBinding.instance.addPostFrameCallback((v){
              if(previousOffset != 0) taskGroupScrollController.position.jumpTo(previousOffset);
              // print(taskGroupScrollController.position.moveTo(to));
              final int scrollTime = 500 + taskGroupScrollController.position.extentAfter.toInt();
              taskGroupScrollController.position.moveTo(taskGroupScrollController.position.maxScrollExtent, duration: Duration(milliseconds: scrollTime > 3000 ? 3000 : scrollTime), curve: Curves.decelerate).then((onValue){
                print(taskGroupScrollController.offset);
              });
            });
            // Timer(Duration(milliseconds: 500), (){
              
            // });
          });
        },
      ),
    );
  }

  Widget _buildTaskGroups(BuildContext context, MainModel model) {
    if(model.isLoading){
      return Container(
        padding: EdgeInsets.only(top: getSize(context, 100)),
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    } else if(model.taskGroups.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: getSize(context, 100)),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.no_sim, size: getSize(context, 200), color: Colors.white.withOpacity(0.3),),
            customText.BodyText(text: "No Tasks Yet", fontWeight: FontWeight.w700,)
          ],
        )
      );
    } else {
      // return ListView(
      //   controller: taskGroupScrollController,
      //   scrollDirection: Axis.horizontal,
      //   shrinkWrap: true,
      //   children: List.generate(_taskGroups.length, (int index) => _buildTaskGroup(context, _taskGroups[index])),
      // );
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: taskGroupScrollController,
        child: Row(
          children: List.generate(_taskGroups.length, (int index) => _buildTaskGroup(context, _taskGroups[index])),
        ),
      );
    }
  }

  Widget _buildTaskGroup(BuildContext context, TaskGroup taskGroup){
    final double proressIndicatorWidth = getSize(context, 220);
    final double progress = taskGroup.numTask == 0 ? 0 : ((taskGroup.numTasksCompleted / taskGroup.numTask) * proressIndicatorWidth).roundToDouble();
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => TasksPage(taskGroup, MediaQuery.of(context).size.width, widget.model)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: EdgeInsets.only(right: 10),
        width: getSize(context, 320),
        height: getSize(context, 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Hero(
                //   tag: 'icon' + taskGroup.idx.toString(),
                //   child: 
                  Icon(taskGroup.icon, color: taskGroup.color,),
                // ),
                Expanded(child: Container(),),
                customText.BodyText(text: '${taskGroup.numTask} ${taskGroup.numTask == 1 ? 'Task' : 'Tasks'}', textColor: Colors.grey,),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: taskGroup.color.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(13)
                  ),
                  child: customText.BodyText(text: '${taskGroup.numTasksCompleted} ${taskGroup.numTasksCompleted == 1 ? "Task" : "Tasks"} Completed', fontWeight: FontWeight.w900,),
                ),
                SizedBox(height: 10,),
                customText.TitleText(text: '${taskGroup.name}', textColor: Colors.black,),
                SizedBox(height: getSize(context, 20),),
                // Hero(
                //   tag: 'progress' + taskGroup.idx.toString(),
                //     child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 3, width: proressIndicatorWidth, color: taskGroup.color.withOpacity(0.3),),
                          Container(height: 3, width: progress, color: taskGroup.color,),
                        ],
                      ),
                      customText.TinyText(text: '${taskGroup.progressPercent.toInt()} %', textColor: taskGroup.color,)
                    ],
                  ),
                // )
              ],
            ),
            Container(
              alignment: Alignment.topRight,
              child: Container(
                width: getSize(context, 100),
                height: getSize(context, 150),
                decoration: BoxDecoration(
                  color: taskGroup.color.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(15),
                    topRight: Radius.circular(150),
                    bottomLeft: Radius.circular(1000),
                    // bottomRight: Radius.circular(15)
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}