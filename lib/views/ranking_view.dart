import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lobby_model.dart';
import '../models/movie_model.dart';
import '../models/user_model.dart';
import '../viewmodels/lobby_viewmodel.dart';
import '../viewmodels/movie_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

class RankingView extends StatefulWidget {
  final Lobby selectedLobby;

  const RankingView({super.key, required this.selectedLobby});

  @override
  _RankingViewState createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  late List<int> userRanking;
  Map<int, Movie?> movieMap = {};
  User? currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize userRanking with the movieIds in the current lobby
    userRanking = List.from(widget.selectedLobby.movieIds);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize currentUser in didChangeDependencies to ensure the widget is attached to the context
    if (currentUser == null) {
      _getCurrentUser(context);
    }
  }

  Future<void> _getCurrentUser(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context);

    User user = userViewModel.currentUser!;

    if (mounted) {
      setState(() {
        currentUser = user;
      });
    }
  }

  Future<void> _preloadMovies() async {
    final movieViewModel = MovieViewModel();

    final Map<int, Movie?> fetchedMovies = {};
    for (int movieId in userRanking) {
      final movie = await movieViewModel.getMovie(movieId);
      fetchedMovies[movieId] = movie;
    }
    if (mounted) {
      setState(() {
        movieMap = fetchedMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _preloadMovies();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rank Movies"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex -= 1;
          final movieId = userRanking.removeAt(oldIndex);
          userRanking.insert(newIndex, movieId);
        },
        children: [
          for (int movieId in userRanking)
            ListTile(
              key: ValueKey(movieId),
              title: Text(
                movieMap[movieId]?.title ?? "Movie $movieId",
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          // Store the updated ranking for the current user
          final userId = currentUser!.id;
          storeUserRankings(
              widget.selectedLobby.lobbyId!, userId!, userRanking);
        },
      ),
    );
  }

  void storeUserRankings(int lobbyId, int userId, List<int> ranking) async {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context, listen: false);

    await lobbyViewModel.storeUserRanking(lobbyId, userId, ranking);

    showFinalRankings(context, lobbyId);
  }

  void showFinalRankings(BuildContext context, int lobbyId) async {
    try {
      final lobbyViewModel =
          Provider.of<LobbyViewModel>(context, listen: false);

      final sortedMovies = await lobbyViewModel.processRankings(lobbyId);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Final Ranking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: sortedMovies.map((entry) {
                final movieId = entry.key;
                final average = entry.value;

                // Retrieve the movie title using the movieMap
                final movieTitle = movieMap[movieId]?.title ?? 'Unknown Movie';

                return Text(
                  '$movieTitle: ${average.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                );
              }).toList(),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
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
}
