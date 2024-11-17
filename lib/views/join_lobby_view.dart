// lobby_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home_view.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
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
      body: const Center(
        child: Text('Welcome to the Lobby!'),
      ),
    );
  }
}
