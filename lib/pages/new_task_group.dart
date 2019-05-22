import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/task.dart';

import '../widgets/custom_text.dart' as customText;

class NewTaskGroupPage extends StatefulWidget{
  final List<TaskGroup> taskGroups;

  NewTaskGroupPage(this.taskGroups);

  @override
  _NewTaskGroupPageState createState() => _NewTaskGroupPageState();
}

class _NewTaskGroupPageState extends State<NewTaskGroupPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _text;
  List _colors = [
    Colors.orange,
    Colors.green,
    Colors.purple
  ];
  int _selectedIdx = 0;
  List<bool> _selected = [];

  List<IconData> _icons = [
    Icons.work,
    Icons.person,
    Icons.home,
    Icons.face,
    Icons.search,
    Icons.library_books,
    Icons.book,
    Icons.call
  ];
  int _selectedIconIdx = 0;
  List<bool> _selectedIcon = [];

  List<bool> _generateBoolList(int length, int trueIndex){
    List<bool> l = [];
    for(int i = 0; i < length; i++){
      l.add(false);
    }

    l[trueIndex] = true;
    return l;
  }

  @override
  void initState() {
    _selected = _generateBoolList(_colors.length, 0);
    _selectedIcon = _generateBoolList(_icons.length, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task Group'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Task Group",
                        hintText: "e.g. Work, Home, Personal"
                      ),
                      validator: (String value){
                        if(value.isEmpty) return 'Enter a new Task Group';
                      },
                      onSaved: (String value){
                        _text = value;
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 40,),
              customText.TitleText(text: 'Select Color', textColor: Colors.black,),
              SizedBox(height: 10,),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                crossAxisSpacing: 20,
                children: List.generate(_colors.length, (int index) => GestureDetector(
                  onTap: (){
                    if(index == _selectedIdx) return;
                    _selectedIdx = index;
                    setState(() {
                      for(int i = 0 ; i < _selected.length; i++) {
                        _selected[i] = false;
                      }
                     _selected[_selectedIdx] = true; 
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: _colors[index],
                          shape: BoxShape.circle,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _selected[index] ? 1 : 0,
                        curve: Curves.easeIn,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check,
                            color: Colors.white,
                            size: 30,),
                        ),
                      )
                    ],
                  ),
                )),
              ),
              SizedBox(height: 40,),
              customText.TitleText(text: 'Select Icon', textColor: Colors.black,),
              SizedBox(height: 10,),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                crossAxisSpacing: 20,
                children: List.generate(_colors.length, (int index) => GestureDetector(
                  onTap: (){
                    if(index == _selectedIconIdx) return;
                    _selectedIconIdx = index;
                    setState(() {
                      for(int i = 0 ; i < _selectedIcon.length; i++) {
                        _selectedIcon[i] = false;
                      }
                     _selectedIcon[_selectedIconIdx] = true; 
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey)
                        ),
                        child: Icon(_icons[index]),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _selectedIcon[index] ? 1 : 0,
                        curve: Curves.easeIn,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model){
          return FloatingActionButton(
            heroTag: 'add_task',
            child: Icon(Icons.add),
            onPressed: (){
              if(_formKey.currentState.validate()){
                _formKey.currentState.save();
                model.addTaskGroup(TaskGroup(
                  idx: widget.taskGroups.length,
                  icon: _icons[_selectedIconIdx],
                  name: _text,
                  numTask: 0,
                  numTasksCompleted: 0,
                  color: _colors[_selectedIdx],
                  progressPercent: 0,
                  tasks: []
                  // dateTime: DateTime.now(),
                )).then((_){
                  Navigator.of(context).pop();
                });
              }
            },
          );
        },
      ),
    );
  }
}