import 'package:flutter/material.dart';
import 'package:movwe/services/movie_database_service.dart';

import '../models/movie_model.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieDatabaseService _movieDatabaseService = MovieDatabaseService();

  Future<List<Movie>> getAllMovies() async {
    return _movieDatabaseService.getAllMovies();
  }

  Future<List<Movie>> search(String query) async {
    return _movieDatabaseService.searchMoviesByTitle(query);
  }

  Future<Movie?> getMovie(int id) async {
    return _movieDatabaseService.getMovieById(id);
  }
}
