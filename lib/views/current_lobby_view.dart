import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lobby_model.dart';
import '../viewmodels/lobby_viewmodel.dart';
import '../models/movie_model.dart';
import '../viewmodels/movie_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import './ranking_view.dart';
import 'home_view.dart';

class CurrentLobbyView extends StatefulWidget {
  const CurrentLobbyView({super.key});

  @override
  State<CurrentLobbyView> createState() => _CurrentLobbyViewState();
}

class _CurrentLobbyViewState extends State<CurrentLobbyView> {
  Lobby? _selectedLobby;
  List<Movie?> movieList = [];
  List<Lobby> lobbies = [];
  final _movieViewModel = MovieViewModel();
  final lobbyViewModel = LobbyViewModel();
  final TextEditingController _searchController = TextEditingController();

  List<Movie> _searchResults = [];
  bool _isLoading = false;

  Future<void> _updateSelectedLobby(BuildContext context, int? id) async {
    if (id != null) {
      _selectedLobby = await lobbyViewModel.getLobby(id);
      await _loadMovies();
    }
  }

  Future<void> _loadMovies() async {
    List<Movie?> fetchedMovies = [];

    for (int movieId in _selectedLobby?.movieIds ?? []) {
      final movie = await _movieViewModel.getMovie(movieId);
      fetchedMovies.add(movie);
    }

    setState(() {
      movieList = fetchedMovies;
    });
  }

  Future<void> _getLobbies(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context);
    final lobbyIds = await userViewModel.getLobbyIdsForCurrentUser();

    List<Lobby> fetchedLobbies = [];
    for (int id in lobbyIds) {
      final lobby = await lobbyViewModel.getLobby(id);
      if (lobby != null) {
        fetchedLobbies.add(lobby);
      }
    }

    setState(() {
      lobbies = fetchedLobbies;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getLobbies(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLobby != null ? "Lobby ${_selectedLobby!.lobbyId}" : "Lobby",
        ),
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
          Center(
            child: DropdownButton<int>(
              value: _selectedLobby?.lobbyId,
              hint: const Text('Select a Lobby'),
              items: lobbies.map((lobby) {
                return DropdownMenuItem<int>(
                  value: lobby.lobbyId,
                  child: Text("Lobby ${lobby.lobbyId}"),
                );
              }).toList(),
              onChanged: (int? newLobby) {
                setState(() {
                  _updateSelectedLobby(context, newLobby);
                });
              },
            ),
          ),
          if (_selectedLobby != null) ...[
            Expanded(
              child: ListView.builder(
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  final movie = movieList[index];
                  if (movie == null) {
                    return const ListTile(
                      title: Text("Loading..."),
                    );
                  }
                  return ListTile(
                    title: Text(movie.title),
                  );
                },
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
                            lobbyViewModel.addMovie(_selectedLobby!, movie);
                            _loadMovies();
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
                  MaterialPageRoute(
                    builder: (context) => RankingView(
                      selectedLobby: _selectedLobby!,
                    ),
                  ),
                );
              },
              child: const Text("Rank Movies"),
            ),
          ]
        ],
      ),
    );
  }
}
