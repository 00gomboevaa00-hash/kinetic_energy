import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/kinetic_record.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'kinetic.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kinetic_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mass REAL NOT NULL,
        velocity REAL NOT NULL,
        energy REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(KineticRecord r) async {
    final d = await database;
    return d.insert('kinetic_records', r.toMap()..remove('id'));
  }

  Future<List<KineticRecord>> getAll() async {
    final d = await database;
    final maps = await d.query('kinetic_records', orderBy: 'created_at DESC');
    return maps.map(KineticRecord.fromMap).toList();
  }

  Future<KineticRecord?> getById(int id) async {
    final d = await database;
    final maps = await d.query('kinetic_records',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return KineticRecord.fromMap(maps.first);
  }

  Future<int> update(KineticRecord r) async {
    final d = await database;
    return d.update('kinetic_records', r.toMap()..remove('id'),
        where: 'id = ?', whereArgs: [r.id]);
  }

  Future<int> delete(int id) async {
    final d = await database;
    return d.delete('kinetic_records', where: 'id = ?', whereArgs: [id]);
  }
}