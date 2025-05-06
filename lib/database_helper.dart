import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {

    final path = join(await getDatabasesPath(), 'dictionary.db');
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE words (
            id INTEGER PRIMARY KEY,
            word TEXT,
            definition TEXT
          )
        ''');

        // Insert sample words
        await db.insert('words', {'word': 'verisimilitude', 'definition': 'the appearance of being true or real'});
        await db.insert('words', {'word': 'realism', 'definition': 'representation of things as they actually are'});
        await db.insert('words', {'word': 'serendipity', 'definition': 'finding valuable things not sought for'});
        await db.insert('words', {'word': 'ephemeral', 'definition': 'lasting for a very short time'});
        await db.insert('words', {'word': 'lucid', 'definition': 'expressed clearly; easy to understand'});
        await db.insert('words', {'word': 'ineffable', 'definition': 'too great to be expressed in words'});
        await db.insert('words', {'word': 'sonder', 'definition': 'the realization that everyone has a complex life'});
        await db.insert('words', {'word': 'limerence', 'definition': 'the state of being infatuated'});
        await db.insert('words', {'word': 'epoch', 'definition': 'a particular period of time in history'});
        await db.insert('words', {'word': 'solitude', 'definition': 'the state of being alone'});
      },
    );
  }

  Future<Map<String, dynamic>?> getDefinition(String word) async {
    final db = await database;
    final result = await db.query('words', where: 'word = ?', whereArgs: [word]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getSimilarWords(String input) async {
    final db = await database;
    return await db.query('words', where: 'word LIKE ?', whereArgs: ['%$input%']);
  }
}
