import 'package:flutter/material.dart';
import 'dart:async';

import '../scoped-models/main.dart';
import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import './add_task.dart';

class TaskPage extends StatefulWidget{
  final TaskGroup taskGroup;
  final deviceWidth;
  final MainModel model;

  TaskPage(this.taskGroup, this.deviceWidth, this.model);

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage> with SingleTickerProviderStateMixin{
  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * widget.deviceWidth + 10.136);
  }

  Map<String, List<Task>> _taskWithDates = Map();

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  AnimationController _progressController;
  Tween<double> _progressTween;
  Animation<double> _progressAnimation;
  double _progress = 0;
  double _proressIndicatorWidth;
  double _progressFraction = 0;

  bool _showHistorySheet = false;

  @override
  void initState() {
    _progressController = new AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    // _progressTween = new Tween<double>(begin: 0, end: 300);
    _proressIndicatorWidth = _getSize(370);
    if(widget.taskGroup.numTask != 0)
      _progressFraction = (widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask);
    animateProgress();
    
    _taskWithDates = _createListWithDates();
    print(_taskWithDates);
    super.initState();
  }

  Map<String, List<Task>> _createListWithDates(){
    if(widget.taskGroup.tasks.length == 0) return Map<String, List<Task>>();

    Map<String, List<Task>> map = Map<String, List<Task>>();
    List<Task> tasks = List.from(widget.taskGroup.tasks);
    DateTime currentDate = tasks[0].dateTime;
    for(int i = 0; i < tasks.length; ){
      if(isDay(tasks[i].dateTime, currentDate.day, currentDate.month)){
        if(map["${currentDate.month} ${currentDate.day}"] == null) map["${currentDate.month} ${currentDate.day}"] = List<Task>();
        map["${currentDate.month} ${currentDate.day}"].add(tasks[i]);
        i++;
      } else{
        currentDate = tasks[i].dateTime;
      }
    }
    return map;
  }

  _displayHistory(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        List<String> dateKeys = _taskWithDates.keys.toList();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: List.generate(dateKeys.length, (int index) {
              DateTime now = DateTime.now();
              if(dateKeys[index] == "${now.month} ${now.day}") return Container();

              List<Task> tasks = _taskWithDates[dateKeys[index]];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  customText.TitleText(text: dateKeys[index], textColor: Colors.black87,),
                  Column(
                    children: List.generate(tasks.length, (int index){
                      return buildOldTask(tasks[index]);
                    }),
                  ),
                  SizedBox(height: 10,)
                ],
              );
            }),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!_showHistorySheet && _taskWithDates.length > 0){
      Timer(Duration(seconds: 2), () => _displayHistory(context));
      _showHistorySheet = true;
    }

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
              //   tag: '_progress' + widget.taskGroup.idx.toString(),
              //   child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 3, width: _proressIndicatorWidth, color: widget.taskGroup.color.withOpacity(0.3),),
                        Container(height: 3, width: _progressAnimation.value, color: widget.taskGroup.color,),
                      ],
                    ),
                    SizedBox(width: 7,),
                    customText.BodyText(text: '${(_progressFraction * 100).round()} %', textColor: widget.taskGroup.color,)
                  ],
                ),
              // )
            SizedBox(height: 20,),
            customText.BodyText(text: 'TODAY', textColor: Colors.grey,),
            SizedBox(height: 20,),
            Container(
              // padding: const EdgeInsets.all(8.0),
              height: MediaQuery.of(context).size.height - 300,
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
          )).then((_){
            animateProgress();
          });
        },
        backgroundColor: widget.taskGroup.color,
      ),
    );
  }

  Widget buildOldTask(Task task) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        color: widget.taskGroup.color,
        child: Icon(Icons.add, color: Colors.white, size: 30,),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        color: Colors.grey,
        child: Icon(Icons.delete_forever, color: Colors.white, size: 30,),
      ),
      onDismissed: (DismissDirection dir){

      },
      child: ListTile(
        // key: UniqueKey(),
        contentPadding: EdgeInsets.only(left: 0),
        leading: Checkbox(
          value: task.done,
          activeColor: widget.taskGroup.color,
        ),
        title: Text(task.info, style: task.done ? TextStyle(
          color: Colors.black54,
          decoration: TextDecoration.lineThrough,
        ) : TextStyle(),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: (){

              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: widget.taskGroup.color,),
              onPressed: (){

              },
            ),
          ],
        ),
        onTap: (){

        },
      ),
    );
  }

  Widget buildTask(Task task) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        color: Colors.grey,
        child: Icon(Icons.delete_forever, color: Colors.white, size: 30,),
      ),
      onDismissed: (DismissDirection dir){

      },
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0),
        leading: Checkbox(
          value: task.done,
          activeColor: widget.taskGroup.color,
          onChanged: (bool value){
            setState(() {
             task.done = value; 
            });
            value ? widget.taskGroup.numTasksCompleted++ : widget.taskGroup.numTasksCompleted--;
            animateProgress();
            widget.model.saveTasks();
          },
        ),
        title: Text(task.info, style: task.done ? TextStyle(
          color: Colors.black54,
          decoration: TextDecoration.lineThrough,
        ) : TextStyle(),),
        // trailing: customText.BodyText(text: isToday(task.dateTime) ? "Today" : "${months[task.dateTime.month]} ${task.dateTime.day}", textColor: Colors.black87,),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: (){
            
          },
        ),
        onTap: (){

        },
      ),
    );
  }

  void animateProgress() {
    final double currentProgress = _progress;
    if(widget.taskGroup.numTask != 0)
      _progressFraction = (widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask);
    _progress = widget.taskGroup.numTasksCompleted == 0 ? 0 : (_progressFraction * _proressIndicatorWidth).roundToDouble();
    
    _progressTween = new Tween<double>(begin: currentProgress, end: _progress);
    _progressController.reset();
    _progressAnimation = _progressTween.animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut
    ))
      ..addListener((){
        // print(_progressAnimation.value);
        setState(() {
          
        });
      });
    _progressController.forward();
  }

  bool isDay(DateTime dateTime, int day, int month){
    return dateTime.day == day && dateTime.month == month;
  }

  bool isToday(DateTime dateTime){
    DateTime now = DateTime.now();
    return dateTime.day == now.day && dateTime.month == now.month;
  }

  @override
  void dispose() {
    // widget.model.saveTasks();
    _progressController.dispose();
    super.dispose();
  }
}
