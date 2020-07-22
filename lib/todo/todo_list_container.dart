import 'package:flutter/material.dart';
import 'package:flutter_app_todo/todo/todo_header.dart';
import 'package:flutter_app_todo/todo/todo_list.dart';

class TodoListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TodoHeader(),
          Expanded(child: TodoList()),
        ],
      ),
    );
  }
}
