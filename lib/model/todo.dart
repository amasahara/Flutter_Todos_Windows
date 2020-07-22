class Todo {
  final int id;
  final String content;

  Todo({this.id, this.content});

  Todo.fromData(this.id, this.content);

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'content': content
    };
  }
}
