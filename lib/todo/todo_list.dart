import 'package:flutter/material.dart';
import 'package:flutter_app_todo/bloc/todo_bloc.dart';
import 'package:flutter_app_todo/event/delete_todo_event.dart';
import 'package:flutter_app_todo/model/todo.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var bloc = Provider.of<TodoBloc>(context);
    bloc.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (context, bloc, child) => StreamBuilder<List<Todo>>(
          stream: bloc.todoListStream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data[index].content,
                          style: TextStyle(fontSize: 19),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            bloc.event
                                .add(DeleteTodoEvent(snapshot.data[index]));
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red[400],
                          ),
                        ),
                      );
                    });
              case ConnectionState.waiting:
                return Center(
                  child: Container(
                    width: 70,
                    height: 80,
                    child: Text("Empty", style: TextStyle(fontSize: 18),),
                  ),
                );
              case ConnectionState.none:
              default:
                return Center(
                  child: Container(
                    width: 70,
                    height: 80,
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          }),
    );
  }
}
