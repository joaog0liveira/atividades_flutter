import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/shared_preferences_service.dart';

class SharedPreferencesViewModel extends ChangeNotifier {
  final SharedPreferencesService _service = SharedPreferencesService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _service.loadTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    _tasks.add(newTask);
    notifyListeners();

    try {
      await _service.saveTasks(_tasks);
    } catch (e) {
      _error = e.toString();
      _tasks.removeLast();
      notifyListeners();
    }
  }

  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final oldTask = _tasks[index];
    _tasks[index] = oldTask.copyWith(done: !oldTask.done);
    notifyListeners();

    try {
      await _service.saveTasks(_tasks);
    } catch (e) {
      _error = e.toString();
      _tasks[index] = oldTask;
      notifyListeners();
    }
  }

  Future<void> removeTask(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final removedTask = _tasks.removeAt(index);
    notifyListeners();

    try {
      await _service.saveTasks(_tasks);
    } catch (e) {
      _error = e.toString();
      _tasks.insert(index, removedTask);
      notifyListeners();
    }
  }

  Future<void> clearAllTasks() async {
    final oldTasks = List<Task>.from(_tasks);
    _tasks.clear();
    notifyListeners();

    try {
      await _service.clearTasks();
    } catch (e) {
      _error = e.toString();
      _tasks = oldTasks;
      notifyListeners();
    }
  }
}
