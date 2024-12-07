import 'package:flutter/material.dart';
import 'package:movwe/models/user_model.dart';
import 'package:movwe/services/lobby_database_service.dart';
import 'package:movwe/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/lobby_model.dart';
import '../models/movie_model.dart';

class LobbyViewModel extends ChangeNotifier {
  final LobbyDatabaseService _lobbyDatabaseService = LobbyDatabaseService();
  Lobby? _currentLobby;
  Lobby? get currentLobby => _currentLobby;
  User? currentUser;
  int? _joinCode;
  int? get joinCode => _joinCode;

  // Get a lobby by ID
  Future<Lobby?> getLobby(int id) async {
    return await _lobbyDatabaseService.getLobbyById(id);
  }

  // Create a new lobby
  Future<bool> createLobby(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    currentUser = userViewModel.currentUser;
    try {
      Lobby lobby;
      if (currentUser != null) {
        int? userId = currentUser?.id;
        // Create a new Lobby model
        if (userId != null) {
          lobby =
              Lobby(qrCode: "qrcode.png", adminId: userId, memberIds: [userId]);
        } else {
          return false;
        }
        // Save the lobby to the database
        int lobbyId = await _lobbyDatabaseService.createLobby(lobby);
        //print the lobby id
        print("Lobby ID: $lobbyId");
        _joinCode = lobbyId;
        // Add the lobbyId to the user's lobbyIds
        final updatedLobbyIds = List<int>.from(currentUser!.lobbyIds)
          ..add(lobbyId);
        currentUser!.lobbyIds = updatedLobbyIds;
        // Update the user in the database
        await userViewModel.updateUser(currentUser!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error creating lobby: ${e.toString()}");
      return false;
    }
  }

  Future<bool> joinLobby(BuildContext context, int? lobbyId) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    // Get the current user
    final currentUser = userViewModel.currentUser;
    if (currentUser == null) {
      throw Exception("No user found");
    }
    if (lobbyId == null) {
      throw Exception("Invalid lobby ID");
    }
    // Fetch the lobby from the database
    final lobby = await _lobbyDatabaseService.getLobbyById(lobbyId);
    if (lobby == null) {
      throw Exception('Lobby $lobbyId not found');
    }

    if (lobby.status == "OPEN") {
      // Check to see if user is already in lobby
      if (lobby.memberIds.contains(currentUser.id)) return false;
      // Add the user to the lobby's memberIds
      final updatedMemberIds = List<int>.from(lobby.memberIds)
        ..add(currentUser.id!);
      lobby.memberIds = updatedMemberIds;
      // Update the lobby in the database
      await _lobbyDatabaseService.updateLobby(lobby);

      // Add the lobbyId to the user's lobbyIds
      await userViewModel.addLobby(lobbyId);

      return true;
    } else {
      throw Exception("Join failed: Lobby $lobbyId has been finalized.");
    }
  }

  Future<void> updateLobby(Lobby lobby) async {
    await _lobbyDatabaseService.updateLobby(lobby);
  }

  Future<void> addMovie(Lobby lobby, Movie movie) async {
    if (lobby.status == "OPEN") {
      if (!lobby.movieIds.contains(movie.movieId)) {
        lobby.movieIds.add(movie.movieId!);
        await updateLobby(lobby);
      }
    } else {
      throw Exception("The lobby has been finalized.");
    }
  }

  Future<void> storeUserRanking(
      int lobbyId, int userId, List<int> movieRanking) async {
    Lobby? lobby = await getLobby(lobbyId);
    if (lobby == null) {
      throw Exception("No lobby is currently selected.");
    }

    lobby.userRankings[userId] = movieRanking;

    await updateLobby(lobby);
  }

  Future<List<MapEntry<int, double>>> processRankings(int lobbyId) async {
    final lobby = await getLobby(lobbyId);
    if (lobby == null) {
      throw Exception("Lobby with ID $lobbyId not found");
    }

    final userRankings = lobby.userRankings;
    final Map<int, int> positionSums = {};
    final Map<int, int> counts = {};

    // Calculate total scores and counts for each movie
    for (var rankings in userRankings.values) {
      for (int position = 0; position < rankings.length; position++) {
        final movieId = rankings[position];
        positionSums[movieId] = (positionSums[movieId] ?? 0) + position + 1;
        counts[movieId] = (counts[movieId] ?? 0) + 1;
      }
    }

    // Calculate average scores
    final Map<int, double> averageScores = positionSums.map((movieId, total) {
      final count = counts[movieId] ?? 1;
      return MapEntry(movieId, total / count);
    });

    // Sort movies by their average scores in ascending order
    final sortedMovies = averageScores.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sortedMovies;
  }

  Future<bool> removeUserFromLobby(
      BuildContext context, Lobby lobby, User user) async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      // remove lobby from user
      userViewModel.removeLobby(user, lobby.lobbyId!);

      // remove user from lobby
      lobby.memberIds.remove(user.id);
      updateLobby(lobby);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateStatus(Lobby lobby, String status) async {
    lobby.status = status;

    updateLobby(lobby);
  }

  Future<void> resetRankings(Lobby lobby) async {
    lobby.userRankings = {};

    updateLobby(lobby);
  }

  Future<void> deleteLobby(
      BuildContext context, Lobby lobby, User currentUser) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    for (int memberId in lobby.memberIds) {
      final user = await userViewModel.getUser(memberId);

      if (user != null && lobby.adminId != user.id) {
        await userViewModel.removeLobby(user, lobby.lobbyId!);
      }
    }

    await removeUserFromLobby(context, lobby, currentUser);
    await _lobbyDatabaseService.deleteLobby(lobby.lobbyId!);
  }
}
