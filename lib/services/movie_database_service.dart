import '../models/movie_model.dart';
import './database_service.dart';

class MovieDatabaseService {
  // Add movie to DB
  Future<int> addMovie(Movie movie) async {
    final db = await DatabaseService.database;
    return await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await DatabaseService.database;

    List<Map<String, dynamic>> maps = await db.query('movies');

    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  // Search movies by title
  Future<List<Movie>> searchMoviesByTitle(String searchQuery) async {
    final db = await DatabaseService.database;

    List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'LOWER(title) LIKE ?',
      whereArgs: ['%${searchQuery.toLowerCase()}%'],
    );

    // Convert the list of maps to a list of Movie objects
    return maps.map((map) => Movie.fromMap(map)).toList();
  }
}
