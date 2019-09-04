import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskrunz/pages/onboarding.dart';

import './scoped-models/main.dart';

import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'TaskRunz',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Color.fromRGBO(41, 51, 92, 1),
          // accentColor: Colors.orange,
          fontFamily: 'Nunito'
        ),
        // home: HomePage(_model),
        home: OnboardingPage(_model),
      ),
    );
  }
}