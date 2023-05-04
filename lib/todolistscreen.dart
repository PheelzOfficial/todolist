import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'todos.dart';

class TodoListScreen extends StatefulWidget {
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodos();
  }

  getTodos() async {
    await Provider.of<Todos>(context, listen: false).loadFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final todos = Provider.of<Todos>(context, listen: false);
              todos.removeCompleted();
            },
          )
        ],
      ),
      body: Consumer<Todos>(
        builder: (context, todos, child) {
          return ListView.builder(
            itemCount: todos.todos.length,
            itemBuilder: (context, index) {
              final todo = todos.todos[index];
              return CheckboxListTile(
                title: Text(todo.title),
                value: todo.isCompleted,
                onChanged: (value) {
                  todo.isCompleted = value ?? false;
                  todos.notifyListeners();
                  todos.saveToPrefs();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('New Todo'),
                content: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Enter todo item'),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controller.clear();
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      final todos = Provider.of<Todos>(context, listen: false);
                      todos.add(_controller.text);
                      Navigator.of(context).pop();
                      _controller.clear();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
