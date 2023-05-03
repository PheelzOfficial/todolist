import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  String title;
  bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
  });
}

class Todos with ChangeNotifier {
  List<Todo> todos = [];

  Todos() {
    loadFromPrefs();
  }

  void add(String title) {
    todos.add(Todo(title: title));
    notifyListeners();
    saveToPrefs();
  }

  void removeCompleted() {
    todos.removeWhere((todo) => todo.isCompleted);
    notifyListeners();
    saveToPrefs();
  }

  void saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = todos.map((todo) => '${todo.title}:${todo.isCompleted}').toList();
    prefs.setStringList('todos', todoStrings);
  }

  void loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = prefs.getStringList('todos') ?? [];

    todos = todoStrings.map((todoString) {
      final split = todoString.split(':');
      return Todo(
        title: split[0],
        isCompleted: split[1] == 'true',
      );
    }).toList();

    notifyListeners();
  }
}
