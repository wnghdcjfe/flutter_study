// task_viewmodel.dart
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskViewModel extends ChangeNotifier {
  Map<String, dynamic>? bitcoinData;
  Timer? _timer;
  Future<void> fetchBitcoinData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.upbit.com/v1/candles/minutes/1?market=KRW-BTC&count=1'),
        headers: {'accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        bitcoinData = jsonDecode(response.body)[0];
        notifyListeners(); // Notify UI of the update
      } else {
        throw Exception('Failed to load Bitcoin data');
      }
    } catch (e) {
      print('Error fetching Bitcoin data: $e');
    }
  }

  // 5초마다 주기적으로 fetchBitcoinData() 호출
  void startFetchingBitcoinData() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchBitcoinData();
    });
  }

  // 타이머 종료
  void stopFetchingBitcoinData() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopFetchingBitcoinData();
    super.dispose();
  }
  final TaskModel _taskModel = TaskModel();
  List<String> _todoList = [];

  List<String> get todoList => _todoList;

  TaskViewModel() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _todoList = await _taskModel.loadTasks();
    notifyListeners();  // Notify UI that data has changed
  }

  void addTask(String task) {
    if (!_todoList.contains(task)) {
      _todoList.insert(0, task);
      saveTasks();
      notifyListeners();
    }
  }

  void removeTask(int index) {
    _todoList.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    await _taskModel.saveTasks(_todoList);
  }
}
