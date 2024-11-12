import '../models/user_model.dart';
import '../models/lobby_model.dart';

class UserViewmodel {
  User? _user;
  User? get user => _user;

  Future<bool> login(String username, String password) async {
    if (_user != null && _user!.authenticate(username, password)) {
      return true;
    } else {
      return false;
    }
  }

  void updateUserProfile(String newUsername, String profilePic) {
    if (_user != null) {
      _user!.update({'username': newUsername, 'profilePic': profilePic});
    }
  }

  void joinLobby(Lobby lobby) {
    if (_user != null) {
      _user!.joinLobby(lobby);
    }
  }

  void leaveLobby(Lobby lobby) {
    if (_user != null) {
      _user!.leaveLobby(lobby);
    }
  }

}