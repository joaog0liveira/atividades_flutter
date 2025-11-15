import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class FileService {
  static const String _fileName = 'tasks.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final file = await _localFile;
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      final jsonString = json.encode(tasksJson);
      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Erro ao salvar tarefas no arquivo: $e');
    }
  }

  Future<List<Task>> loadTasks() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();

      if (contents.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar tarefas do arquivo: $e');
    }
  }

  Future<void> clearTasks() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Erro ao limpar arquivo: $e');
    }
  }

  Future<bool> fileExists() async {
    try {
      final file = await _localFile;
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
