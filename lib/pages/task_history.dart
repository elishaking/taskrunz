import 'package:flutter/material.dart';

import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

class TaskHistoryPage extends StatefulWidget{
  final TaskGroup taskGroup;
  final Map<String, List<Task>> taskWithDates;

  TaskHistoryPage(this.taskGroup, this.taskWithDates);

  @override
  _TaskHistoryPageState createState() => _TaskHistoryPageState();
}

class _TaskHistoryPageState extends State<TaskHistoryPage> {
  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    List<String> dateKeys = widget.taskWithDates.keys.toList();
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: widget.taskGroup.color
        ),
      ),
      body: _noHistory(dateKeys) ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.no_sim, size: 200, color: widget.taskGroup.color.withOpacity(0.3),),
            customText.BodyText(text: "No Old Tasks Yet", textColor: widget.taskGroup.color,
            fontWeight: FontWeight.w900,)
          ],
        )
      ) : Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: List.generate(dateKeys.length, (int index) {
            // DateTime now = DateTime.now();
            // if(dateKeys[index] == "${months[now.month]} ${now.day}") return Container();

            List<Task> tasks = widget.taskWithDates[dateKeys[index]];
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
      ),
    );
  }

  bool _noHistory(List<String> dateKeys) {
    DateTime now = DateTime.now();
    return dateKeys.length == 0 || (dateKeys.length == 1 && dateKeys[0] == "${months[now.month]} ${now.day}");
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
}