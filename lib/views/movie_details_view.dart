import 'package:flutter/material.dart';
import '../viewmodels/lobby_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';

class MovieDetailsView extends StatelessWidget {
  final Movie movie;
  const MovieDetailsView({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => _selectLobbyAndAddMovie(context, movie),
          child: const Text('+'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Future<void> _selectLobbyAndAddMovie(
      BuildContext context, Movie movie) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final List<int> lobbies = userViewModel.currentUser!.lobbyIds;

    if (lobbies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must join a lobby first.')),
      );
      return;
    }

    // Show a dialog or bottom sheet to select a lobby
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Lobby'),
          content: SingleChildScrollView(
            child: Column(
              children: lobbies.map((lobbyId) {
                return ListTile(
                  title: Text('Lobby $lobbyId'),
                  onTap: () {
                    _addMovieToLobby(context, lobbyId, movie);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addMovieToLobby(
      BuildContext context, int lobbyId, Movie movie) async {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context, listen: false);

    try {
      // Fetch the lobby details
      final lobby = await lobbyViewModel.getLobby(lobbyId);
      if (lobby != null) {
        // Add movie ID to the lobby's movieIds list
        await lobbyViewModel.addMovie(lobby, movie);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie added to lobby!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lobby not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding movie to lobby.')),
      );
    }
  }
}
