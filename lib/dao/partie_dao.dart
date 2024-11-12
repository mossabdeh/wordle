

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

     return await openDatabase(
       path,
       version: 1,
       onCreate: (db, version) async {
         await db.execute('''
          CREATE TABLE parties(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            secretWord TEXT,
            date TEXT,
            attempts INTEGER,
            guessedLetters TEXT,
            gameMode TEXT
          )
        ''');
       },
     );
   }

   // Insert a new completed game (PartieEntity) into the database
   Future<int> insertPartie(PartieEntity partie) async {
     final db = await database;
     return await db.insert('parties', partie.toMap(),
         conflictAlgorithm: ConflictAlgorithm.replace);
   }

   // Retrieve all saved games
   Future<List<PartieEntity>> getParties() async {
     final db = await database;
     final List<Map<String, dynamic>> maps = await db.query('parties');
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
     db?.close();
   }
 }
