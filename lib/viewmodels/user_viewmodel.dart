import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_database_service.dart';

class UserViewModel extends ChangeNotifier {
  static final UserViewModel _instance = UserViewModel._internal();
  final UserDatabaseService _userDatabaseService = UserDatabaseService();
  User? _currentUser;

  factory UserViewModel() {
    return _instance;
  }

  UserViewModel._internal();

  // Getter for the current user
  User? get currentUser => _currentUser;

  // Set the current user
  void setCurrentUser(User? user) {
    _currentUser = user;
  }

  // Create account
  Future<bool> createAccount(String username, String password) async {
    try {
      // Create a new User model
      final user = User(
          username: username,
          password: password,
          profilePic: '',
          topGenres: [],
          lobbyIds: []);

      // Save the user to the database
      await _userDatabaseService.addUser(user);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get a user by ID
  Future<User?> getUser(int id) async {
    return await _userDatabaseService.getUserById(id);
  }

  // Update a user
  Future<void> updateUser(User user) async {
    await _userDatabaseService.updateUser(user);
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    await _userDatabaseService.deleteUser(id);
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    return await _userDatabaseService.getAllUsers();
  }

  Future<User?> authenticate(String username, String password) async {
    try {
      final user = await _userDatabaseService.authenticate(username, password);

      setCurrentUser(user);

      return user;
    } catch (e) {
      throw Exception('Authentication failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<List<int>> getLobbyIdsForCurrentUser() async {
    return currentUser!.lobbyIds;
  }

  Future<void> addLobby(int lobbyId) async {
    final updatedLobbyIds = List<int>.from(currentUser!.lobbyIds)..add(lobbyId);
    currentUser!.lobbyIds = updatedLobbyIds;

    updateUser(currentUser!);
  }

  Future<void> removeLobby(User user, int lobbyId) async {
    user.lobbyIds.remove(lobbyId);

    updateUser(user);
  }
}
