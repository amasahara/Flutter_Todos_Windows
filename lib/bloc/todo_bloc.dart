import 'dart:async';
import 'dart:math';
import 'package:flutter_app_todo/base/base_bloc.dart';
import 'package:flutter_app_todo/base/base_event.dart';
import 'package:flutter_app_todo/db/todo_table.dart';
import 'package:flutter_app_todo/event/add_todo_event.dart';
import 'package:flutter_app_todo/event/delete_todo_event.dart';
import 'package:flutter_app_todo/model/todo.dart';

class TodoBloc extends BaseBloc {
  TodoTable _todoTable = TodoTable();
  StreamController<List<Todo>> _todoStreamController =
      StreamController<List<Todo>>();

  Stream<List<Todo>> get todoListStream => _todoStreamController.stream;

  var _randomInt = Random();
  List<Todo> _todoListData = List<Todo>();

  //thực hiện lấy danh sách các dữ liệu trong db
  initData() async {
    _todoListData = await _todoTable.selectAllTodo();
    if (_todoListData == null) {
      return;
    }
    _todoStreamController.sink.add(_todoListData);
  }

  _addTodo(Todo todo) async {
    //insert to db
    await _todoTable.insertTodo(todo);
    _todoListData.add(todo);
    _todoStreamController.sink.add(_todoListData);
  }

  _deleteTodo(Todo todo) async {
    //remove todo from db
    await _todoTable.deleteTodo(todo);

    _todoListData.remove(todo);
    _todoStreamController.sink.add(_todoListData);
  }

  @override
  void dispatchEvent(BaseEvent event) {
    if (event is AddTodoEvent) {
      Todo todo = Todo.fromData(_randomInt.nextInt(10000), event.content);
      _addTodo(todo);
    } else if (event is DeleteTodoEvent) {
      _deleteTodo(event.todo);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _todoStreamController.close();
  }
}
