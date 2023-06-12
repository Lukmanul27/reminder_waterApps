import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'reminderwater.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE modes (
        id INTEGER PRIMARY KEY,
        mode TEXT
      )
    ''');
  }

  Future<void> insertMode(String mode) async {
    final db = await instance.database;
    await db.insert('modes', {'mode': mode});
  }

  Future<String?> getMode() async {
    final db = await instance.database;
    final results = await db.query('modes');
    if (results.isNotEmpty) {
      return results.first['mode'] as String?;
    }
    return null;
  }

  Future<void> updateMode(String mode) async {
    final db = await instance.database;
    await db.update('modes', {'mode': mode});
  }
}
