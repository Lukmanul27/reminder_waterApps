import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class inDb {
  static final inDb instance = inDb._();

  static Database? _database;

  inDb._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'settings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE settings (id INTEGER PRIMARY KEY, interval INTEGER)');
      },
    );
  }

  Future<void> saveInterval(int interval) async {
    final db = await instance.database;
    await db.insert('settings', {'interval': interval},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getInterval() async {
    final db = await instance.database;
    final result = await db.query('settings', orderBy: 'id DESC', limit: 1);
    if (result.isNotEmpty) {
      return result.first['interval'] as int;
    }
    return 60; // Interval default jika tidak ada data dalam database
  }
}
