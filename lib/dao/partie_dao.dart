import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entities/partie.dart';

/* Data Access Object DAO for partie entity (database Helper) */
class PartieDAO {
  static final PartieDAO _instance = PartieDAO._internal();
  factory PartieDAO() => _instance;

  static Database? _database;

  PartieDAO._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'parties_database.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 2, // Updated version to 2
      onCreate: (db, version) async {
        print("Creating new database...");
        await db.execute('''
          CREATE TABLE parties(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            secretWord TEXT,
            date TEXT,
            attempts INTEGER,
            guessedLetters TEXT,
            gameMode TEXT,
            wordLength INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          print("Upgrading database and adding wordLength column...");
          await db.execute('ALTER TABLE parties ADD COLUMN wordLength INTEGER');
        }
      },
    );
  }

  // Insert a new completed game (PartieEntity) into the database
  Future<int> insertPartie(PartieEntity partie) async {
    final db = await database;
    print('Inserting PartieEntity into database: ${partie.toMap()}');
    try {
      int id = await db.insert('parties', partie.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('Insert successful, new id: $id');
      return id;
    } catch (e) {
      print('Insert failed with error: $e');
      return -1; // Return -1 or handle error as needed
    }
  }

  // Retrieve all saved games
  Future<List<PartieEntity>> getParties() async {
    final db = await database;
    print('Fetching all parties from database...');
    final List<Map<String, dynamic>> maps = await db.query('parties');
    print('Fetched ${maps.length} parties');
    return List.generate(maps.length, (i) => PartieEntity.fromMap(maps[i]));
  }

  // Optional: Delete a specific game record by ID
  Future<void> deletePartie(int id) async {
    final db = await database;
    await db.delete(
      'parties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await _database;
    await db?.close();
  }
}
