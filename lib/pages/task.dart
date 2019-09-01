import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../scoped-models/main.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

import '../utils/responsive.dart';

class TaskPage extends StatefulWidget{
  final TaskGroup taskGroup;
  final int taskIndex;
  final MainModel model;

  TaskPage(this.taskGroup, this.taskIndex, this.model);

  @override
  _TaskPageState createState() => _TaskPageState();
}


String repeatOption = RepeatOptions.days;
bool repeatDateSet = false;
int repeatValue;

class _TaskPageState extends State<TaskPage> {
  Task task;
  DateTime dueDate;
  TimeOfDay dueTime;
  DateTime remindDate;
  TimeOfDay remindTime;

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    task = widget.taskGroup.tasks[widget.taskIndex];
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@drawable/notification_icon');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload){
      print(payload);
    });
      // onSelectNotification: (String payLoad) async{
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) => AlertDialog(
      //       title: Text("Reminder"),
      //       content: Text("Notification"),
      //     )
      //   );
      // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: customText.BodyText(text: '',),
      //   centerTitle: true,
      //   elevation: 0,
      //   iconTheme: IconThemeData(
      //     color: widget.taskGroup.color
      //   ),
      // ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        color: Colors.white,
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model){
            return Column(
              children: <Widget>[
                _buildTaskHeading(context),
                SizedBox(height: 20,),
                _buildTaskActions(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Card _buildTaskHeading(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     offset: Offset(0, 2),
          //     spreadRadius: 0.7,
          //     blurRadius: 1
          //   ),
          // ]
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: widget.taskGroup.color,),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Checkbox(
                value: task.done,
                onChanged: (bool value){
                  setState(() {
                    task.done = value; 
                  });
                  value ? widget.taskGroup.numTasksCompleted++ : widget.taskGroup.numTasksCompleted--;
                  widget.taskGroup.progressPercent = (widget.taskGroup.numTasksCompleted / widget.taskGroup.numTask) * 100;
                  widget.model.saveTasks();
                },
              ),
              title: customText.HeadlineText(text: task.info, textColor: widget.taskGroup.color,),
            ),
            SizedBox(height: 5,),
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.add, color: widget.taskGroup.color,),
                  SizedBox(width: 10,),
                  customText.BodyText(text: "Add Step", textColor: widget.taskGroup.color,)
                ],
              ),
              onPressed: (){
                
              },
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Card _buildTaskActions(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     offset: Offset(0, 0),
          //     spreadRadius: 1,
          //     blurRadius: 3
          //   ),
          // ]
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.calendar_today, color: dueDate == null ? null : widget.taskGroup.color),
              title: dueDate == null ? Text("Due Date",) : Text("Due ${dueTime.hour}:${dueDate.minute}", style: TextStyle(color: widget.taskGroup.color)),
              subtitle: dueDate == null ? null : Text("${months[dueDate.month]} ${dueDate.day}"),
              onTap: (){
                showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 360)),
                  initialDate: DateTime.now().add(Duration(hours: 2))
                ).then((DateTime date){
                  if(date != null){
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 3)
                    ).then((TimeOfDay time){
                      setState(() {
                        dueDate = date;
                        dueTime = time; 
                      });
                    });;
                  }
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.alarm, color: remindDate == null ? null : widget.taskGroup.color),
              title: remindDate == null ? Text("Remind Date",) : Text("Remind me at ${remindTime.hour}:${remindTime.minute}", style: TextStyle(color: widget.taskGroup.color)),
              subtitle: remindTime == null ? null : Text("${months[remindDate.month]} ${remindDate.day}"),
              onTap: (){
                showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 360)),
                  initialDate: DateTime.now().add(Duration(hours: 2))
                ).then((DateTime date){
                  if(date != null){
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1)))
                    ).then((TimeOfDay time){
                      if(time != null){
                        setState(() {
                          remindDate = date;
                          remindTime = time; 
                          // String dateString = "${date.year}-0${date.month}-0${date.day}T${remindTime.hour}:${remindTime.minute}:30.799371Z";
                          print(date.toIso8601String());
                          print(time.format(context));
                          remindDate = DateTime(date.year, date.month, date.day, date.hour - 2, time.minute, date.second); // DateTime.parse(dateString);
                          print(remindDate.toIso8601String());
                        });
                        _setNotification();
                      }
                    });;
                  }
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.repeat, color: repeatValue == null ? null : widget.taskGroup.color,),
              title: _buildRepeatTitle(),
              onTap: (){
                _showRepeatOptionsDialog(context).then((_){
                  setState(() {});
                });
              },
            ),
            // Divider(),
          ],
        ),
      ),
    );
  }

  void _setNotification() async{
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    // print(DateTime.now().millisecondsSinceEpoch ~/ 1000000);
    await flutterLocalNotificationsPlugin.cancelAll();
    print(remindDate.toIso8601String());
    List<PendingNotificationRequest> pendingNotificationRequest = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    // flutterLocalNotificationsPlugin.show(10100, "new", "test", notificationDetails);
    print("${DateTime.now().timeZoneName} <--> ${DateTime.now().timeZoneOffset} <--> ${DateTime.now().toLocal().toIso8601String()} <--> ${DateTime.now().toUtc().toIso8601String()} <--> ${DateTime.now().toIso8601String()}");
    flutterLocalNotificationsPlugin.schedule(
      pendingNotificationRequest == null ? 0 : pendingNotificationRequest.length,
      "Pending Task", 
      "task.info", 
      DateTime.now().add(Duration(seconds: 10)), 
      notificationDetails
    ).then((_){
      print("notification set");
    });

    flutterLocalNotificationsPlugin.pendingNotificationRequests().then((List<PendingNotificationRequest> reqs){
      print("Pending Notifications:");
      reqs.forEach((PendingNotificationRequest req){
        print("${req.id}\n${req.title}\n${req.body}\n");
      });
    });
    // await flutterLocalNotificationsPlugin.periodicallyShow(
    //   DateTime.now().millisecondsSinceEpoch,
    //   "Pending Task", 
    //   task.info, 
    //   RepeatInterval.Daily, 
    //   notificationDetails
    // );
  }

  // RepeatInterval _getNotificationRepeattInterval(){
  //   if(repeatOption == RepeatOptions.days)
  // }

  Text _buildRepeatTitle(){
    if(repeatDateSet){
      return Text(
        repeatValue == 1 ? _singularRepeatText() : "Every $repeatValue $repeatOption", 
        style: TextStyle(color: widget.taskGroup.color,)
      );
    }
    return Text("Repeat");
  }

  String _singularRepeatText(){
    if(repeatOption == RepeatOptions.days) return "Daily";
    else if(repeatOption == RepeatOptions.weeks) return "Weekly";
    else if(repeatOption == RepeatOptions.months) return "Monthly";
    else return "Yearly";
  }

  Future _showRepeatOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: getSize(context, 30), vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                customText.TitleText(text: "Repeat Every", textColor: widget.taskGroup.color,),
                SizedBox(height: 20,),
                RepeatOptionsMenu(),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      textColor: widget.taskGroup.color,
                      onPressed: (){
                        repeatDateSet = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        );
      }
    );
  }
}

class RepeatOptionsMenu extends StatefulWidget {
  @override
  _RepeatOptionsMenuState createState() => _RepeatOptionsMenuState();
}

class _RepeatOptionsMenuState extends State<RepeatOptionsMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (String value){
              repeatValue = int.parse(value);
            },
          ),
        ),
        SizedBox(width: 30,),
        Flexible(
          flex: 4,
          child: DropdownButton<String>(
            value: repeatOption,
            items: [RepeatOptions.days, RepeatOptions.months, RepeatOptions.weeks, RepeatOptions.years].map((String option) => DropdownMenuItem(child: Text(option), value: option,)).toList(),
            onChanged: (String value){
              // print(value);
              setState(() {
                repeatOption = value; 
              });
            },
          ),
        )
      ],
    );
  }
}

class RepeatOptions{
  static final String days = "days";
  static final String weeks = "weeks";
  static final String months = "months";
  static final String years = "years";
}
