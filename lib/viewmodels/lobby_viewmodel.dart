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
    try {
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
        print('lobby $lobbyId not found');
        return false;
      }
      // Check to see if user is already in lobby
      if (lobby.memberIds.contains(currentUser.id)) return false;
      // Add the user to the lobby's memberIds
      final updatedMemberIds = List<int>.from(lobby.memberIds)
        ..add(currentUser.id!);
      lobby.memberIds = updatedMemberIds;
      // Update the lobby in the database
      await _lobbyDatabaseService.updateLobby(lobby);
      // Add the lobbyId to the user's lobbyIds
      final updatedLobbyIds = List<int>.from(currentUser.lobbyIds)
        ..add(lobbyId);
      currentUser.lobbyIds = updatedLobbyIds;

      // Update the user in the database
      await userViewModel.updateUser(currentUser);

      return true;
    } catch (e) {
      print("Error joining lobby: $e");
      return false;
    }
  }

  Future<void> updateLobby(Lobby lobby) async {
    await _lobbyDatabaseService.updateLobby(lobby);
  }

  Future<void> addMovie(Lobby lobby, Movie movie) async {
    if (!lobby.movieIds.contains(movie.movieId)) {
      lobby.movieIds.add(movie.movieId!);
      await updateLobby(lobby);
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
}
