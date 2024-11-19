import 'dart:math';
import 'package:flutter/material.dart';

class LobbyViewModel with ChangeNotifier {
  final Map<int, List<String>> _lobbies = {}; // Maps join codes to movie lists
  int? joinCode;

  // Generates a unique join code
  Future<bool> createLobby(BuildContext context) async {
    final random = Random();
    joinCode = random.nextInt(900000) + 100000; // Generate 6-digit number
    if (_lobbies.containsKey(joinCode)) {
      return false; // Retry if duplicate
    }
    _lobbies[joinCode!] = [];
    notifyListeners();
    return true;
  }

  // Join a lobby using a code
  Future<bool> joinLobby(BuildContext context, int code) async {
    if (_lobbies.containsKey(code)) {
      joinCode = code;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Retrieve movies for the current lobby
  List<String> get movies => _lobbies[joinCode] ?? [];

  // Add a movie to the current lobby
  void addMovie(String movie) {
    if (joinCode != null && _lobbies.containsKey(joinCode)) {
      _lobbies[joinCode]!.add(movie);
      notifyListeners();
    }
  }

  // Clear the current lobby
  void clearLobby() {
    joinCode = null;
    notifyListeners();
  }

  // Retrieve a specific lobby by its join code
  List<String>? getLobby(int code) {
    return _lobbies[code];
  }
}
