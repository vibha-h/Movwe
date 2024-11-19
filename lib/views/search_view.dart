import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../viewmodels/movie_viewmodel.dart';
import 'home_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _movieViewModel = MovieViewModel();
  List<Movie> _movies = [];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                _setMovies(query); //call the search function in the view_model
              },
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: MovieResultsList(movies: _movies),
          ),
        ],
      ),
    );
  }

  Future<void> _setMovies(String query) async {
    final movies = await _movieViewModel.search(query); // Perform search
    setState(() {
      _movies = movies;
      _query = query;
    });
  }
}

class MovieResultsList extends StatelessWidget {
  final List<Movie> movies;

  const MovieResultsList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length, //replace with actual data length
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(movie.title),
          subtitle: Text(movie.description),
          onTap: () => _showMovieDetails(context, movie),
        );
      },
    );
  }

  void _showMovieDetails(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            movie.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  movie.moviePoster,
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  movie.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Genre: ${movie.genre}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Content Rating: ${movie.contentRating}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'IMDb Rating: ${movie.IMDbRating}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
