import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    print('Db path: $path');

    return openDatabase(
      path,
      onCreate: (db, version) {
        // Create all the tables here
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT, profilePic TEXT, topGenres TEXT, lobbies TEXT)',
        );
        db.execute(
          'CREATE TABLE movies(id INTEGER PRIMARY KEY AUTOINCREMENT, moviePoster TEXT, title TEXT, description TEXT, genre TEXT, contentRating TEXT, IMDbRating TEXT, reviews TEXT, numberOfSelections INTEGER)',
        );
        db.execute(
          'CREATE TABLE lobbies(id INTEGER PRIMARY KEY AUTOINCREMENT, qrCode TEXT, adminId INTEGER, memberIds TEXT, movieIds TEXT, userRankings TEXT, status TEXT)',
        );
      },
      version: 1,
    );
  }
}