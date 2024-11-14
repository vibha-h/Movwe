import './database_service.dart';
import '../models/lobby_model.dart';

class LobbyDatabaseService {
  Future<void> createLobby(Lobby lobby) async{
    final db = await DatabaseService.database;
    await db.insert('lobbies', lobby.toMap());
  }
}