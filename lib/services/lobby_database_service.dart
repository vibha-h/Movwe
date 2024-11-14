import './database_service.dart';
import '../models/lobby_model.dart';

class LobbyDatabaseService {

  // Create a lobby
  Future<int> createLobby(Lobby lobby) async {
    final db = await DatabaseService.database;
    return await db.insert('lobbies', lobby.toMap());
  }

  // Get a lobby by ID
  Future<Lobby?> getLobbyById(int id) async {
    final db = await DatabaseService.database;
    List<Map<String, dynamic>> maps = await db.query(
      'lobbies',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Lobby.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateLobby(Lobby lobby) async {
    final db = await DatabaseService.database;
    return await db.update(
      'lobbies',
      lobby.toMap(),
      where: 'id = ?',
      whereArgs: [lobby.lobbyId],
    );
  }
}