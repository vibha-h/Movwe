import 'dart:math';
import 'package:flutter/material.dart';

class LobbyViewModel with ChangeNotifier {
  final Map<int, List<String>> _lobbies = {}; // Maps join codes to movie lists
  final Map<int, Map<String, List<String>>> _userRankings =
      {}; // Maps join codes to user rankings
  int? joinCode;

  // Getter for user rankings
  Map<int, Map<String, List<String>>> get userRankings => _userRankings;

  Future<bool> createLobby(BuildContext context) async {
    final random = Random();
    joinCode = random.nextInt(9000) + 1000; // Generate 4-digit number
    print('Join Code: $joinCode');
    if (_lobbies.containsKey(joinCode)) {
      return false; // Retry if duplicate
    }
    _lobbies[joinCode!] = [];
    _userRankings[joinCode!] = {};
    notifyListeners();
    return true;
  }

  Future<bool> joinLobby(BuildContext context, int code) async {
    if (_lobbies.containsKey(code)) {
      joinCode = code;
      notifyListeners();
      return true;
    }
    return false;
  }

  List<String> get movies => _lobbies[joinCode] ?? [];

  void addMovie(String movie) {
    if (joinCode != null && _lobbies.containsKey(joinCode)) {
      _lobbies[joinCode]!.add(movie);
      notifyListeners();
    }
  }

  void clearLobby() {
    joinCode = null;
    notifyListeners();
  }

  List<String>? getLobby(int code) {
    return _lobbies[code];
  }

  void storeUserRanking(String userId, List<String> ranking) {
    if (!userRankings.containsKey(joinCode)) {
      userRankings[joinCode!] = {};
    }
    userRankings[joinCode]![userId] = ranking;

    //print('Updated rankings for $userId: $ranking');
  }

  List<String> processRankings() {
    //print('Processing rankings for joinCode: $joinCode');
    final userRankingsForJoinCode = userRankings[joinCode];
    //print('All user rankings: $userRankingsForJoinCode');
    // if (userRankingsForJoinCode == null) { //will not occur? will count default order as ranking
    //   print("no rankings");
    //   return [];
    // }

    // Calculate total scores and average
    final Map<String, double> movieScores = {};
    for (var rankings in userRankingsForJoinCode!.values) {
      for (int i = 0; i < rankings.length; i++) {
        final movie = rankings[i];
        movieScores[movie] = (movieScores[movie] ?? 0) + (i + 1);
      }
    }

    // Compute averages
    final averageScores = movieScores.map((movie, score) {
      final count = userRankingsForJoinCode.values
          .where((ranking) => ranking.contains(movie))
          .length;
      return MapEntry(movie, score / count);
    });

    // Sort movies by average score
    final sortedMovies = averageScores.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sortedMovies.map((entry) => entry.key).toList();
  }
}
