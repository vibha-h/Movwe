import './lobby_model.dart';

class User {
  String userId;
  String username;
  String password;
  String profilePic;
  List<String> topGenres;
  List<Lobby> lobbies;

  User({
    required this.userId,
    required this.username,
    required this.password,
    this.profilePic = '',
    this.topGenres = const [],
    this.lobbies = const [],
  });

  //TODO
  bool authenticate(String username, String password){
    return false;
  }

  //TODO
  void update(Map<String, dynamic> body){
    return;
  }

  //TODO
  User getProfileDetails(){
    return this;
  }

  //TODO
  void joinLobby(Lobby lobby){
    lobbies.add(lobby);
    return;
  }

  //TODO
  void leaveLobby(Lobby lobby){
    lobbies.remove(lobby);
    return;
  }
}