import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lobby_viewmodel.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  _RankingViewState createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  List<String> userRanking = [];
  late String userId; // Unique user identifier

  @override
  void initState() {
    super.initState();
    // Generate a unique user ID (could also come from user input)
    userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context);
    final List<String> movies = lobbyViewModel.movies;

    //accept default ranking if user does not change it
    if (userRanking.isEmpty) {
      userRanking = List.from(movies);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rank Movies"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex -= 1;
          final movie = movies.removeAt(oldIndex);
          movies.insert(newIndex, movie);
          setState(() {
            userRanking = List.from(movies);
          });
        },
        children: [
          for (int index = 0; index < movies.length; index++)
            ListTile(
              key: ValueKey(index),
              title: Text(movies[index]),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          // Store user ranking with dynamic user ID
          lobbyViewModel.storeUserRanking(userId, userRanking);

          // Process rankings
          final sortedMovies = lobbyViewModel.processRankings();

          // Display the final ranking with average scores
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Final Ranking'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sortedMovies.map((movie) {
                    // Fetch average score for the movie
                    final joinCode = lobbyViewModel.joinCode;
                    final userRankings = lobbyViewModel.userRankings[joinCode];
                    final scores = userRankings?.values
                        .map((ranking) => ranking.indexOf(movie) + 1)
                        .where((score) => score > 0)
                        .toList();
                    final average = scores != null && scores.isNotEmpty
                        ? scores.reduce((a, b) => a + b) / scores.length
                        : 0.0;

                    return Text('${average.toStringAsFixed(2)} $movie');
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
        },
      ),
    );
  }
}
