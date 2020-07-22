import 'package:flutter/material.dart';
import 'package:flutter_app_todo/bloc/todo_bloc.dart';
import 'package:flutter_app_todo/db/todo_database.dart';
import 'package:flutter_app_todo/todo/todo_list_container.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoDatabase.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
        ),
        body: Provider<TodoBloc>.value(
            value: TodoBloc(), child: TodoListContainer()),
      ),
    );
  }
}
