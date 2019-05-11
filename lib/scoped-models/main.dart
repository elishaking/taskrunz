import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class MainModel extends Model with ConnectedModel, TaskModel {}

class ConnectedModel extends Model{

}

class TaskModel extends ConnectedModel{

}