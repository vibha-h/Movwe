import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lobby_viewmodel.dart';
import '../models/movie_model.dart';
import '../viewmodels/movie_viewmodel.dart';
import './ranking_view.dart';

class CurrentLobbyView extends StatefulWidget {
  const CurrentLobbyView({super.key});

  @override
  State<CurrentLobbyView> createState() => _CurrentLobbyViewState();
}

class _CurrentLobbyViewState extends State<CurrentLobbyView> {
  final _movieViewModel = MovieViewModel();
  final TextEditingController _searchController = TextEditingController();

  List<Movie> _searchResults = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context);

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
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Search and Add a Movie",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) async {
                    if (query.isEmpty) {
                      setState(() {
                        _searchResults = [];
                      });
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    final results = await _movieViewModel.search(query);
                    setState(() {
                      _searchResults = results;
                      _isLoading = false;
                    });
                  },
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (_searchResults.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
                      return ListTile(
                        leading: Image.asset(
                          movie.moviePoster,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(movie.title),
                        //subtitle: Text(movie.description),
                        onTap: () {
                          if (!lobbyViewModel.movies.contains(movie.title)) {
                            lobbyViewModel.addMovie(movie.title);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text("${movie.title} added!"),
                            //   ),
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${movie.title} is already in the list."),
                              ),
                            );
                          }
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      );
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
