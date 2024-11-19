import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/movie_model.dart';

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
      onCreate: (db, version) async {
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

        // initialize basic movie data
        await _insertMovies(db);
      },
      version: 1,
    );
  }

  static Future<void> _insertMovies(Database db) async {
    final List<Movie> movies = [
      Movie(
        movieId: 1,
        moviePoster: 'assets/images/prideAndPrej.jpg',
        title: 'Pride and Prejudice',
        description: 'Description of Movie 1',
        genre: 'Romance',
        contentRating: 'PG',
        IMDbRating: '9.1',
        reviews: [],
        numberOfSelections: 0,
      ),
      Movie(
        movieId: 2,
        moviePoster: 'assets/images/scoobydoo.jpg',
        title: 'Scooby Doo',
        description: 'Description of Movie 2',
        genre: 'Comedy',
        contentRating: 'PG',
        IMDbRating: '8.0',
        reviews: [],
        numberOfSelections: 0,
      ),
      Movie(
        movieId: 3,
        moviePoster: 'assets/images/spiderman.jpg',
        title: 'Spiderman - Into the Spiderverse',
        description: 'Description of Movie 3',
        genre: 'Animated',
        contentRating: 'PG',
        IMDbRating: '9.3',
        reviews: [],
        numberOfSelections: 0,
      ),
      Movie(
        movieId: 4,
        moviePoster: 'assets/images/gladiator.jpg',
        title: 'Gladiator',
        description: 'Description of Movie 4',
        genre: 'Drama',
        contentRating: 'R',
        IMDbRating: '7.3',
        reviews: [],
        numberOfSelections: 0,
      ),
      Movie(
        movieId: 5,
        moviePoster: 'assets/images/batman.jpg',
        title: 'Dark Knight Rises',
        description: 'Description of Movie 5',
        genre: 'Action',
        contentRating: 'PG-13',
        IMDbRating: '8.5',
        reviews: [],
        numberOfSelections: 0,
      ),
      Movie(
        movieId: 6,
        moviePoster: 'assets/images/dune.jpg',
        title: 'Dune',
        description: 'Description of Movie 6',
        genre: 'Sci-Fi',
        contentRating: 'PG',
        IMDbRating: '9.3',
        reviews: [],
        numberOfSelections: 0,
      ),
      Movie(
        movieId: 7,
        moviePoster: 'assets/images/hugo.jpg',
        title: 'Hugo',
        description: 'Description of Movie 7',
        genre: 'Adventure',
        contentRating: 'PG',
        IMDbRating: '7.4',
        reviews: [],
        numberOfSelections: 0,
      ),
    ];

    for (Movie movie in movies) {
      await db.insert('movies', movie.toMap());
    }
  }
}
