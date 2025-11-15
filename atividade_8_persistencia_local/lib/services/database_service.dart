import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'tasks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'tasks_database.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      throw Exception('Erro ao inicializar banco de dados: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        done INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    try {
      final db = await database;
      await db.insert(
        _tableName,
        {
          'id': task.id,
          'title': task.title,
          'done': task.done ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erro ao inserir tarefa: $e');
    }
  }

  Future<List<Task>> loadTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);

      return maps.map((map) {
        return Task(
          id: map['id'] as String,
          title: map['title'] as String,
          done: (map['done'] as int) == 1,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final db = await database;
      await db.update(
        _tableName,
        {
          'title': task.title,
          'done': task.done ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final db = await database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Erro ao deletar tarefa: $e');
    }
  }

  Future<void> clearTasks() async {
    try {
      final db = await database;
      await db.delete(_tableName);
    } catch (e) {
      throw Exception('Erro ao limpar tarefas: $e');
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
