import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lobby_viewmodel.dart';
import './ranking_view.dart';

class CurrentLobbyView extends StatelessWidget {
  const CurrentLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context);
    final TextEditingController movieController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby ${lobbyViewModel.joinCode}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lobbyViewModel.movies.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(lobbyViewModel.movies[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: movieController,
                    decoration: const InputDecoration(
                      labelText: "Add a Movie",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final movie = movieController.text;
                    if (movie.isNotEmpty) {
                      lobbyViewModel.addMovie(movie);
                      movieController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RankingView()),
              );
            },
            child: const Text("Rank Movies"),
          ),
        ],
      ),
    );
  }
}
