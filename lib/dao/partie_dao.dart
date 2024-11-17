import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entities/partie.dart';

/// Data Access Object (DAO) for managing `PartieEntity` database operations.
///
/// The `PartieDAO` class provides methods to interact with the SQLite database
/// storing game session data. This includes creating, reading, updating, and
/// deleting `PartieEntity` records.
class PartieDAO {
  /// Singleton instance of `PartieDAO`.
  static final PartieDAO _instance = PartieDAO._internal();

  /// Factory constructor to return the singleton instance.
  factory PartieDAO() => _instance;

  /// Internal constructor for singleton pattern.
  PartieDAO._internal();

  /// The SQLite database instance.
  static Database? _database;

  /// Getter to initialize and retrieve the database instance.
  ///
  /// Ensures the database is initialized once and reused across operations.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the SQLite database.
  ///
  /// - Sets the database path to `parties_database.db`.
  /// - Creates the `parties` table with the required columns if it does not exist.
  /// - Upgrades the database schema if needed.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'parties_database.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 2, // Current database version.
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

  /// Inserts a new `PartieEntity` into the database.
  ///
  /// - [partie]: The `PartieEntity` to be inserted.
  /// - Returns: The ID of the newly inserted record, or -1 if the operation fails.
  ///
  /// Example:
  /// ```dart
  /// final id = await partieDAO.insertPartie(partie);
  /// ```
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
      return -1; // Return -1 or handle error as needed.
    }
  }

  /// Retrieves all saved `PartieEntity` records from the database.
  ///
  /// - Returns: A list of `PartieEntity` objects representing all saved game sessions.
  ///
  /// Example:
  /// ```dart
  /// final parties = await partieDAO.getParties();
  /// print('Total games: ${parties.length}');
  /// ```
  Future<List<PartieEntity>> getParties() async {
    final db = await database;
    print('Fetching all parties from database...');
    final List<Map<String, dynamic>> maps = await db.query('parties');
    print('Fetched ${maps.length} parties');
    return List.generate(maps.length, (i) => PartieEntity.fromMap(maps[i]));
  }

  /// Deletes a specific game session from the database by ID.
  ///
  /// - [id]: The ID of the game session to delete.
  ///
  /// Example:
  /// ```dart
  /// await partieDAO.deletePartie(1);
  /// ```
  Future<void> deletePartie(int id) async {
    final db = await database;
    await db.delete(
      'parties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database connection.
  ///
  /// Example:
  /// ```dart
  /// await partieDAO.close();
  /// ```
  Future<void> close() async {
    final db = await _database;
    await db?.close();
  }
}
