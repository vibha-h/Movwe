import '../models/lobby_model.dart';
import '../models/movie_model.dart';

class LobbyViewModel {
  Lobby? _currentLobby;

  Lobby? get currentLobby => _currentLobby;

  // Create a new lobby
  void createLobby(String lobbyId, String joinCode) {
    // _currentLobby = Lobby(
    //   lobbyId: lobbyId,
    //   joinCode: joinCode,
    // );
  }

  // Add a movie to the lobby
  void addMovie(Movie movie) {
    _currentLobby?.addMovie(movie);
  }

  // Remove a movie from the lobby
  void removeMovie(Movie movie){
    _currentLobby?.removeMovie(movie);
  }

  // Update lobby status
  void updateLobbyStatus(String status) {
    _currentLobby?.updateStatus(status);
  }

  // Finalize lobby setup
  void finalizeLobby() {
    _currentLobby?.finalize();
  }

  // Calculate average rankings
  List<Movie> calculateRankings() {
    return _currentLobby?.calculateAverageRankings() ?? [];
  }
}