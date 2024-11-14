import 'package:flutter/material.dart';
import 'package:movwe/models/user_model.dart';
import 'package:movwe/services/lobby_database_service.dart';
import 'package:movwe/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/lobby_model.dart';

class LobbyViewModel extends ChangeNotifier {
  final LobbyDatabaseService _lobbyDatabaseService = LobbyDatabaseService();
  Lobby? _currentLobby;
  Lobby? get currentLobby => _currentLobby;
  User? currentUser;

  // Create a new lobby
  Future<bool> createLobby(BuildContext context) async{
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    currentUser = userViewModel.currentUser;

    try {
      Lobby lobby;
      int? userId = currentUser?.id;
      // Create a new Lobby model
      if (userId != null){
        lobby = Lobby(qrCode: "qrcode.png", adminId: userId, memberIds: [userId]);
      } else {
        return false;
      }
      
      // Save the user to the database
      await _lobbyDatabaseService.createLobby(lobby);

      return true;
    } catch (e) {
      print("Error creating lobby: ${e.toString()}");
      return false;
    }
  }

  // // Add a movie to the lobby
  // void addMovie(Movie movie) {
  //   _currentLobby?.addMovie(movie);
  // }

  // // Remove a movie from the lobby
  // void removeMovie(Movie movie){
  //   _currentLobby?.removeMovie(movie);
  // }

  // // Update lobby status
  // void updateLobbyStatus(String status) {
  //   _currentLobby?.updateStatus(status);
  // }

  // // Finalize lobby setup
  // void finalizeLobby() {
  //   _currentLobby?.finalize();
  // }

  // // Calculate average rankings
  // List<Movie> calculateRankings() {
  //   return _currentLobby?.calculateAverageRankings() ?? [];
  // }
}