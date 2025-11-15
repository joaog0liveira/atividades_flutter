import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class SharedPreferencesService {
  static const String _tasksKey = 'tasks_list';

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      final jsonString = json.encode(tasksJson);
      await prefs.setString(_tasksKey, jsonString);
    } catch (e) {
      throw Exception('Erro ao salvar tarefas: $e');
    }
  }

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_tasksKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> clearTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tasksKey);
    } catch (e) {
      throw Exception('Erro ao limpar tarefas: $e');
    }
  }
}
