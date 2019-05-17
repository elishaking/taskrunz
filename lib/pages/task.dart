import 'package:flutter/material.dart';

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

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  AnimationController _progressController;
  Tween<double> _progressTween;
  Animation<double> _progressAnimation;
  double _progress = 0;
  double _proressIndicatorWidth;
  double _progressFraction;

  @override
  void initState() {
    _progressController = new AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    // _progressTween = new Tween<double>(begin: 0, end: 300);
    _proressIndicatorWidth = _getSize(380);
    _progressFraction = (widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask);
    animateProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 3, width: _proressIndicatorWidth, color: widget.taskGroup.color.withOpacity(0.3),),
                        Container(height: 3, width: _progressAnimation.value, color: widget.taskGroup.color,),
                      ],
                    ),
                    SizedBox(width: 7,),
                    customText.TinyText(text: '${(_progressFraction * 100).toStringAsFixed(1)} %', textColor: widget.taskGroup.color,)
                  ],
                ),
              // )
            SizedBox(height: 20,),
            // customText.BodyText(text: 'TODAY', textColor: Colors.grey,),
            // SizedBox(height: 20,),
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
          value ? widget.taskGroup.numTasksCompleted++ : widget.taskGroup.numTasksCompleted--;
          animateProgress();
          widget.model.saveTasks();
        },
      ),
      title: Text(task.info),
      trailing: customText.TinyText(text: isToday(task.dateTime) ? "Today" : "${months[task.dateTime.month]} ${task.dateTime.day}", textColor: Colors.black,),
      onTap: (){

      },
    );
  }

  void animateProgress() {
    final double currentProgress = _progress;
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
