import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskapp/models/user_model.dart';

class AuthLocalRepository {
  final String tableName = 'users';
  
  Database? _dataBase;
  
  // Initialize DB
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id Text PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            token TEXT,
            createdAt INTEGER,
            updatedAt INTEGER   
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
  Future<void> insertUser(UserModel user) async {
    final db = await database;
     await db.insert(tableName, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all users
  Future<UserModel?> getUser() async {
    final db = await database;
    final result = await db.query(tableName, limit: 1);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
     return null;
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