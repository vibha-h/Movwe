import 'package:flutter/material.dart';
import 'package:movwe/views/current_lobby_view.dart';
import 'package:movwe/views/home_view.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/lobby_model.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/lobby_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final lobbyViewModel = Provider.of<LobbyViewModel>(context, listen: false);

    final User currentUser = userViewModel.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture and username
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: currentUser.profilePic.isNotEmpty
                      ? NetworkImage(currentUser.profilePic)
                      : const AssetImage('assets/images/defaultProfilePic.jpg')
                          as ImageProvider,
                ),
                const SizedBox(width: 16),
                Text(
                  currentUser.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top genres
            const Text(
              'Top Genres:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            currentUser.topGenres.isEmpty
                ? const Text(
                    'No top genres',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : Wrap(
                    spacing: 8.0,
                    children: currentUser.topGenres.map((genre) {
                      return Chip(
                        label: Text(genre),
                        backgroundColor: Colors.blue.shade100,
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 24),

            // Lobbies
            const Text(
              'Lobbies:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            currentUser.lobbyIds.isEmpty
                ? const Text(
                    'No joined lobbies.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : Wrap(
                    spacing: 8.0,
                    children: currentUser.lobbyIds.map((lobbyId) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CurrentLobbyView(initialLobbyId: lobbyId),
                            ),
                          );
                        },
                        child: Chip(
                          label: Text('Lobby $lobbyId'),
                          backgroundColor: Colors.blue.shade100,
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
