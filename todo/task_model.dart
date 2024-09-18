// task_model.dart
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel {
  Future<List<String>> loadTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('todoList') ?? []).toList();
  }

  Future<void> saveTasks(List<String> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', tasks);
  }
}
