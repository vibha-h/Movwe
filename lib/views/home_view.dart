import 'package:flutter/material.dart';
import 'package:movwe/viewmodels/lobby_viewmodel.dart';
import 'package:movwe/views/login_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _lobbyIdController = TextEditingController();
  String? username;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: username == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome to the Home Page, $username'),
                    const SizedBox(height: 20),
                    // Button to create new lobby
                    ElevatedButton(
                      onPressed: () async {
                        bool isCreated =
                            await lobbyViewModel.createLobby(context);
                        String message = isCreated
                            ? "Lobby Created!"
                            : "Error creating lobby.";
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      },
                      child: const Text("Create Lobby"),
                    ),
                    const SizedBox(height: 20),
                    // TextField to input the lobby ID
                    TextField(
                      controller: _lobbyIdController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Lobby ID',
                        hintText: 'Lobby ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Button to join lobby
                    ElevatedButton(
                      onPressed: () async {
                        int lobbyId =
                            int.tryParse(_lobbyIdController.text) ?? 0;
                        if (lobbyId != 0) {
                          // Call the joinLobby function from LobbyViewModel
                          bool success =
                              await lobbyViewModel.joinLobby(context, lobbyId);

                          // Show success or failure message based on the result
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Successfully joined the lobby!")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Error joining the lobby.")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please enter a valid lobby ID.")),
                          );
                        }
                      },
                      child: const Text("Join Lobby"),
                    ),
                    const SizedBox(height: 20),
                    // Button to logout
                    ElevatedButton(
                      onPressed: () => _logout(),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
