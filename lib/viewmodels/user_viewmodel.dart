import '../models/user_model.dart';
import '../services/user_database_service.dart';

class UserViewModel {
  final UserDatabaseService _userDatabaseService = UserDatabaseService();

  // Create account
  Future<bool> createAccount(String username, String password) async {
    try {
      // Create a new User model
      final user = User(username: username, password: password, profilePic: 'image.png', topGenres: [], lobbyIds: []);
      
      // Save the user to the database
      await _userDatabaseService.addUser(user);
      
      return true;
    } catch (e) {
      print('Error: $e');
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
}