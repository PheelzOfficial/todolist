import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytodo/todolistscreen.dart';

import 'todos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Todos(),
      child: MaterialApp(
        title: 'Todo App',
        home: TodoListScreen(),
      ),
    );
  }
}
