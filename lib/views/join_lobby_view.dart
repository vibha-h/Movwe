import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home_view.dart';
import '../viewmodels/lobby_viewmodel.dart';
import './current_lobby_view.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({super.key});

  @override
  _LobbyViewState createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final TextEditingController _joinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lobbyViewModel = Provider.of<LobbyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              ); // Removed 'const' here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _joinCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Join Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final joinCode = int.tryParse(_joinCodeController.text);
                if (joinCode != null) {
                  bool success =
                      await lobbyViewModel.joinLobby(context, joinCode);
                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrentLobbyView(),
                      ), // Removed 'const' here
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to join lobby.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid join code.")),
                  );
                }
              },
              child: const Text('Join Lobby'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await lobbyViewModel.createLobby(context);
                String message = success
                    ? "Created Lobby: ${lobbyViewModel.joinCode}"
                    : "Failed to create lobby.";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              child: const Text('Create New Lobby'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
