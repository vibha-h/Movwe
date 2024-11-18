import 'package:flutter/material.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  _RankingViewState createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  List<String> rankedMovies = [];

  @override
  void initState() {
    super.initState();
  }

  // Function to add a movie to the ranking list
  void addMovieToRanking(String movie) {
    setState(() {
      rankedMovies.add(movie);
    });
  }

  // Function to handle movie reordering stuff
  void moveMovie(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final movie = rankedMovies.removeAt(oldIndex);
      rankedMovies.insert(newIndex, movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rank Movies')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              addMovieToRanking('Movie 1');  
              addMovieToRanking('Movie 2');  
              addMovieToRanking('Movie 3');  
              // Test with hardcoded movies
            },
            child: const Text("Add Movie"),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: moveMovie,
              children: List.generate(rankedMovies.length, (index) {
                return ListTile(
                  key: ValueKey(rankedMovies[index]),
                  title: Text(rankedMovies[index]),
                  trailing: const Icon(Icons.drag_handle),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
