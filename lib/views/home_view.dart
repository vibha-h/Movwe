import 'package:flutter/material.dart';
import 'package:movwe/viewmodels/movie_viewmodel.dart';
import 'package:movwe/views/add_movie_view.dart';
import 'package:movwe/views/current_lobby_view.dart';
import 'package:movwe/views/join_lobby_view.dart';
import 'package:movwe/views/login_view.dart';
import 'package:movwe/views/profile_view.dart';
import 'package:movwe/views/search_view.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../viewmodels/user_viewmodel.dart';
import 'movie_details_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final movieViewModel = MovieViewModel();
  String? username;

  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final fetchedMovies = await movieViewModel.getAllMovies();
    setState(() {
      movies = fetchedMovies;
    });
  }

  void _showMovieDetails(Movie movie) {
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

  void _logout() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    userViewModel.logout();

    // go back to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final user = userViewModel.currentUser;
    if (user != null) {
      setState(() {
        username = user.username;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${username ?? ''}!'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // search
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SearchView()),
              );
            },
          ),
          TextButton.icon(
              onPressed: () {
                //redirect to lobby view
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LobbyView()),
                );
              },
              label: const Text('Create/Join Lobby'),
              icon: const Icon(Icons.group_add)),
          TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              label: const Text('Profile'),
              icon: const Icon(Icons.person)),
          TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CurrentLobbyView()),
                );
              },
              label: const Text('Lobby'),
              icon: const Icon(Icons.group)),
          TextButton.icon(
              onPressed: _logout,
              label: const Text('Logout'),
              icon: const Icon(Icons.logout_sharp)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddMovieView(),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of movies across
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => MovieDetailsView(movie: movie),
            ),
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      movie.moviePoster,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
