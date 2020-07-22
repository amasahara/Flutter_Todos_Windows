import 'package:flutter_app_todo/base/base_event.dart';
import 'package:flutter_app_todo/model/todo.dart';

class DeleteTodoEvent extends BaseEvent {
  Todo todo;
  DeleteTodoEvent(this.todo);
}