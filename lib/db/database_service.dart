import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    path = join(path, 'water_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE history(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      count INTEGER
    )
  ''');
  }

  Future<void> insertHistory(String date, int count) async {
    final db = await database;
    await db.insert(
      'history',
      {
        'date': date,
        'count': count,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }

  Future<int> getTotalDrinks() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM history');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> updateTotalDrinks(int totalDrinks) async {
    final db = await database;
    await db.rawUpdate('UPDATE history SET count = $totalDrinks');
  }

  Future<void> saveData(int totalDrinks) async {
    final currentDate = DateTime.now().toString();
    await insertHistory(currentDate, totalDrinks);
    await updateTotalDrinks(totalDrinks);
  }
}
