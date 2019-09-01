import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskrunz/pages/home.dart';
import 'package:taskrunz/scoped-models/main.dart';
import 'package:taskrunz/widgets/custom_text.dart';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade800,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Your name",
                    labelStyle: TextStyle(color: Colors.white),
                    icon: Icon(Icons.person, color: Colors.white,),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white,
                    width: 2))
                  ),
                  validator: (String value) {
                    if(value.isEmpty) return "What's your name?";
                  },
                  onSaved: (String value){
                    _name = value;
                  },
                ),
              ),
              SizedBox(height: 40,),
              ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model){
                  return RaisedButton(
                    child: BodyText(text: "BEGIN", textColor: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        model.saveName(_name);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(model)
                        ));
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
