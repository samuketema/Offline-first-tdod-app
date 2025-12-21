import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskapp/models/task_model.dart';
import 'package:taskapp/models/user_model.dart';

class AuthLocalRepository {
  final String tableName = 'tasks';
  
  Database? _dataBase;
  
  // Initialize DB
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id Text PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            uid TEXT NOT NULL,
            dueAt INT NOT NULL,
            color Text NOT NULL,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL  
          )
        ''');
      },
    );
  }

  // Get DB instance
  Future<Database> get database async {
    if (_dataBase != null) return _dataBase!;
    _dataBase = await _initDb();
    return _dataBase!;
  }

  // Insert user
  Future<void> insertTask(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (var task in tasks) {
       batch.insert(tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    }
await batch.commit(noResult: true);
  }

  // Get all users
  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final element in result) {
        tasks.add( TaskModel.fromMap(result.first));
      }
      return tasks;
    }
     return [];
  }

  // Get single user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result =
        await db.query(tableName, where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Clear all users
  Future<int> clearUsers() async {
    final db = await database;
    return await db.delete(tableName);
  }
}