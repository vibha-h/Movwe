import 'package:flutter/material.dart';
import 'package:movwe/viewmodels/lobby_viewmodel.dart';
import 'package:movwe/views/join_lobby_view.dart';
import 'package:movwe/views/login_view.dart';
import 'package:provider/provider.dart';
import 'package:movwe/views/ranking_view.dart';
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
    Movie(
      movieId: '4',
      moviePoster: 'assets/images/gladiator.jpg',
      title: 'Gladiator',
      description: 'Description of Movie 4',
      genre: 'Drama',
      contentRating: 'R',
      IMDbRating: '7.3',
      reviews: [],
      numberOfSelections: 0,
    ),
    Movie(
      movieId: '5',
      moviePoster: 'assets/images/batman.jpg',
      title: 'Dark Knight Rises',
      description: 'Description of Movie 5',
      genre: 'Action',
      contentRating: 'PG-13',
      IMDbRating: '8.5',
      reviews: [],
      numberOfSelections: 0,
    ),
    Movie(
      movieId: '6',
      moviePoster: 'assets/images/dune.jpg',
      title: 'Dune',
      description: 'Description of Movie 6',
      genre: 'Sci-Fi',
      contentRating: 'PG',
      IMDbRating: '9.3',
      reviews: [],
      numberOfSelections: 0,
    ),
    Movie(
      movieId: '7',
      moviePoster: 'assets/images/hugo.jpg',
      title: 'Hugo',
      description: 'Description of Movie 7',
      genre: 'Adventure',
      contentRating: 'PG',
      IMDbRating: '7.4',
      reviews: [],
      numberOfSelections: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _showMovieDetails(Movie movie) {
    showDialog(
      context: context,
      builder: (context) {
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
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final lobbyViewModel = Provider.of<LobbyViewModel>(context, listen: false);

    final user = userViewModel.currentUser;
    if (user != null) {
      setState(() {
        username = user.username;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${username ?? ''}!'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.group_add),
          //   onPressed: () async {
          //     // Implement create/join lobby functionality here
          //     bool isCreated = await lobbyViewModel.createLobby(context);
          //     String message =
          //         isCreated ? "Lobby Created!" : "Error creating lobby.";
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text(message)),
          //     );
          //   },
          // ),
          TextButton.icon(
              onPressed: () {
                // Implement lobby join/create functionality here
                //redirect to lobby view
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LobbyView()),
                );
              },
              label: const Text('Create/Join Lobby'),
              icon: const Icon(Icons.group_add)),
          TextButton.icon(
              onPressed: () {
                // Implement user profile functionality here
              },
              label: const Text('Profile'),
              icon: const Icon(Icons.person)),
          // IconButton(
          //   icon: const Icon(Icons.logout_sharp),
          //   onPressed: _logout,
          // ),
          TextButton.icon(
              onPressed: () {
                // Navigate to the RankingView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RankingView()),
                );
              },
              label: const Text('Go to Ranking'),
              icon: const Icon(Icons.star),
            ),

          TextButton.icon(
              onPressed: _logout,
              label: const Text('Logout'),
              icon: const Icon(Icons.logout_sharp)),
               IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Placeholder for adding movie functionality
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Movie'),
                    content: const Text('Functionality will be implemented later.'),
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
        ],
      ),

      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Number of movies across
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
