import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lobby_viewmodel.dart';

class RankingView extends StatelessWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context);
    final List<String> movies = lobbyViewModel.movies;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rank Movies"),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex -= 1;
          final movie = movies.removeAt(oldIndex);
          movies.insert(newIndex, movie);
          lobbyViewModel.notifyListeners();
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
          // Process rankings logic here
          Navigator.pop(context); // Go back to the lobby
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class RankingView extends StatefulWidget {
//   const RankingView({super.key});

//   @override
//   _RankingViewState createState() => _RankingViewState();
// }

// class _RankingViewState extends State<RankingView> {
//   List<String> rankedMovies = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   // Function to add a movie to the ranking list
//   void addMovieToRanking(String movie) {
//     setState(() {
//       rankedMovies.add(movie);
//     });
//   }

//   // Function to handle movie reordering
//   void moveMovie(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final movie = rankedMovies.removeAt(oldIndex);
//       rankedMovies.insert(newIndex, movie);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rank Movies'),
//         foregroundColor: const Color.fromARGB(255, 242, 202, 202),
//         backgroundColor: const Color.fromARGB(255, 145, 55, 55), // AppBar background color
//       ),
//       body: Container(
//         color: const Color.fromARGB(255, 145, 55, 55), // light red background color for the screen
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 addMovieToRanking('Movie 1');
//                 addMovieToRanking('Movie 2');
//                 addMovieToRanking('Movie 3');
//                 // Test with hardcoded movies
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 58, 24, 24), // Button color
//                 foregroundColor: const Color.fromARGB(255, 242, 202, 202),
//               ),
//               child: const Text("Add Movie"),
//             ),
//             Expanded(
//               child: ReorderableListView(
//                 onReorder: moveMovie,
//                 children: List.generate(rankedMovies.length, (index) {
//                   return Container(
//                     key: ValueKey(rankedMovies[index]),
//                     color: const Color.fromARGB(255, 84, 24, 24), // dark  red for rows
//                     child: ListTile(
//                       title: Text(
//                         rankedMovies[index],
//                         style: const TextStyle(color: Colors.white), // Text color
//                       ),
//                       trailing: const Icon(
//                         Icons.drag_handle,
//                         color: Colors.white, // Icon color
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
