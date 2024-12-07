import 'package:flutter/material.dart';
import 'package:movwe/models/user_model.dart';
import 'package:provider/provider.dart';
import '../models/lobby_model.dart';
import '../viewmodels/lobby_viewmodel.dart';
import '../models/movie_model.dart';
import '../viewmodels/movie_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import './ranking_view.dart';
import 'home_view.dart';

class CurrentLobbyView extends StatefulWidget {
  final int? initialLobbyId;

  const CurrentLobbyView({super.key, this.initialLobbyId});

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

  @override
  void initState() {
    super.initState();
    if (widget.initialLobbyId != null) {
      _updateSelectedLobby(context, widget.initialLobbyId);
    }
  }

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

  User _getCurrentuser(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return userViewModel.currentUser!;
  }

  Future<void> _getLobbies(BuildContext context) async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context);
      final lobbyIds = await userViewModel.getLobbyIdsForCurrentUser();

      List<Lobby> fetchedLobbies = [];
      for (int id in lobbyIds) {
        final lobby = await lobbyViewModel.getLobby(id);
        if (lobby != null) {
          fetchedLobbies.add(lobby);
        }
      }

      if (mounted) {
        setState(() {
          lobbies = List.from(fetchedLobbies);
        });
      }
    } catch (e) {}
  }

  Future<void> _removeMovie(BuildContext context, int movieId) async {
    _selectedLobby!.movieIds.remove(movieId);
    lobbyViewModel.updateLobby(_selectedLobby!);
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
            if (_selectedLobby!.status == "OPEN") ...[
              if (_selectedLobby!.adminId == _getCurrentuser(context).id) ...[
                ElevatedButton(
                    onPressed: () async {
                      bool shouldDelete =
                          await _showConfirmationDialog(context);

                      if (shouldDelete) {
                        await lobbyViewModel.deleteLobby(
                            context, _selectedLobby!, _getCurrentuser(context));

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeView()),
                        );
                      }
                    },
                    child: const Text("Delete Lobby")),
              ] else ...[
                ElevatedButton(
                    onPressed: () async {
                      bool shouldLeave = await _showConfirmationDialog(context);

                      if (shouldLeave) {
                        await lobbyViewModel.removeUserFromLobby(
                            context, _selectedLobby!, _getCurrentuser(context));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeView()),
                        );
                      }
                    },
                    child: const Text("Leave Lobby")),
              ],
            ],
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
                    trailing: _selectedLobby!.status == "OPEN"
                        ? IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () async {
                              try {
                                _removeMovie(context, movie.movieId!);
                                // Reload movies after removal
                                _loadMovies();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Movie removed from lobby")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
            if (_selectedLobby!.status == "OPEN") ...[
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
            ],
            if (_selectedLobby!.status == "FINALIZED") ...[
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
              const SizedBox(height: 8),
              if (_selectedLobby!.adminId == _getCurrentuser(context).id) ...[
                ElevatedButton(
                  onPressed: () {
                    lobbyViewModel.updateStatus(_selectedLobby!, "OPEN");
                    // reset rankings
                    lobbyViewModel.resetRankings(_selectedLobby!);
                  },
                  child: const Text("Open Lobby"),
                ),
              ],
            ],
            if (_selectedLobby!.adminId == _getCurrentuser(context).id &&
                _selectedLobby!.status == "OPEN") ...[
              ElevatedButton(
                onPressed: () {
                  lobbyViewModel.updateStatus(_selectedLobby!, "FINALIZED");
                },
                child: const Text("Finalize Lobby"),
              ),
            ],
            const SizedBox(height: 8),
          ]
        ],
      ),
    );
  }
}

Future<bool> _showConfirmationDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to perform this action?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true (Yes)
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false (No)
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false); // Ensure a bool is returned, even if null
}
