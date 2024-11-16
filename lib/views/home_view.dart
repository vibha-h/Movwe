import 'package:flutter/material.dart';
import 'package:movwe/viewmodels/lobby_viewmodel.dart';
import 'package:movwe/views/login_view.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../viewmodels/user_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _lobbyIdController = TextEditingController();
  String? username;

  final List<Movie> movies = [
    Movie(
      movieId: '1',
      moviePoster: 'assets/images/prideAndPrej.jpg',
      title: 'Pride and Prejudice',
      description: 'Description of Movie 1',
      genre: 'Romance',
      contentRating: 'PG',
      IMDbRating: '9.1',
      reviews: [],
      numberOfSelections: 0,
    ),
    Movie(
      movieId: '2',
      moviePoster: 'assets/images/scoobydoo.jpg',
      title: 'Scooby Doo',
      description: 'Description of Movie 2',
      genre: 'Comedy',
      contentRating: 'PG',
      IMDbRating: '8.0',
      reviews: [],
      numberOfSelections: 0,
    ),
    Movie(
      movieId: '3',
      moviePoster: 'assets/images/spiderman.jpg',
      title: 'Spiderman - Into the Spiderverse',
      description: 'Description of Movie 3',
      genre: 'Animated',
      contentRating: 'PG',
      IMDbRating: '9.3',
      reviews: [],
      numberOfSelections: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _showMovieDetails(Movie movie) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                movie.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Image.asset(movie.moviePoster,
                  height: 200, width: 150, fit: BoxFit.cover),
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
              Text(
                'Reviews: ${movie.reviews.join(', ')}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Number of Selections: ${movie.numberOfSelections}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => _showMovieDetails(movie),
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      movie.moviePoster,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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

  // @override
  // Widget build(BuildContext context) {
  // final userViewModel = Provider.of<UserViewModel>(context, listen: false);
  // final lobbyViewModel = Provider.of<LobbyViewModel>(context, listen: false);

  // final user = userViewModel.currentUser;
  // if (user != null) {
  //   setState(() {
  //     username = user.username;
  //   });
  // }

  // return Scaffold(
  //   appBar: AppBar(title: const Text("Home")),
  //   body: Center(
  //     child: username == null
  //         ? const CircularProgressIndicator()
  //         : Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text('Welcome to the Home Page, $username'),
  //                 const SizedBox(height: 20),
  //                 // Button to create new lobby
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     bool isCreated =
  //                         await lobbyViewModel.createLobby(context);
  //                     String message = isCreated
  //                         ? "Lobby Created!"
  //                         : "Error creating lobby.";
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text(message)),
  //                     );
  //                   },
  //                   child: const Text("Create Lobby"),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 // TextField to input the lobby ID
  //                 TextField(
  //                   controller: _lobbyIdController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Enter Lobby ID',
  //                     hintText: 'Lobby ID',
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 // Button to join lobby
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     int lobbyId =
  //                         int.tryParse(_lobbyIdController.text) ?? 0;
  //                     if (lobbyId != 0) {
  //                       // Call the joinLobby function from LobbyViewModel
  //                       bool success =
  //                           await lobbyViewModel.joinLobby(context, lobbyId);

  //                       // Show success or failure message based on the result
  //                       if (success) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                               content:
  //                                   Text("Successfully joined the lobby!")),
  //                         );
  //                       } else {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                               content: Text("Error joining the lobby.")),
  //                         );
  //                       }
  //                     } else {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                             content:
  //                                 Text("Please enter a valid lobby ID.")),
  //                       );
  //                     }
  //                   },
  //                   child: const Text("Join Lobby"),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 // Button to logout
  //                 ElevatedButton(
  //                   onPressed: () => _logout(),
  //                   child: const Text("Logout"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //   ),
  // );
  //}
}
