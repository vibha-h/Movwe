import 'package:flutter/material.dart';
import 'package:movwe/viewmodels/lobby_viewmodel.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // You can either use currentUser directly if it's nullable
  // Or store the username here to make the widget reactive to changes
  String? username;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final lobbyViewModel = Provider.of<LobbyViewModel>(context, listen:false);
    
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to the Home Page, $username'),
                  const SizedBox(height: 20), // Adds space between the text and button
                  ElevatedButton(
                    onPressed: () async {
                      bool isCreated = await lobbyViewModel.createLobby(context);
                      String message = isCreated? "Lobby Created!" : "Error creating lobby.";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    },
                    child: const Text("Create Lobby"),
                  ),
                ],
              ),
      ),
    );
  }
}