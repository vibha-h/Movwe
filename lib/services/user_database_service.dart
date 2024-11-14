import 'database_service.dart';
import '../models/user_model.dart';

class UserDatabaseService {
  // Add a new user
  Future<void> addUser(User user) async {
    bool isAvailable = await isUsernameAvailable(user.username);
    if (!isAvailable) {
      throw Exception('Username already taken');
    }
    final db = await DatabaseService.database;
    await db.insert('users', user.toMap());
  }

  // Get a user by ID
  Future<User?> getUserById(int id) async {
    final db = await DatabaseService.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Get a user by username
  Future<User?> getUserByUsername(String username) async {
    final db = await DatabaseService.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update user details
  Future<int> updateUser(User user) async {
    final db = await DatabaseService.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete a user by ID
  Future<int> deleteUser(int id) async {
    final db = await DatabaseService.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final db = await DatabaseService.database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<bool> isUsernameAvailable(String username) async {
    final db = await DatabaseService.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isEmpty;
  }

  Future<User?> authenticate(String username, String password) async {
    final db = await DatabaseService.database;

    // Query the database to get the user by username
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    // If a user with the username exists, check the password
    if (maps.isNotEmpty) {
      // Get the user from the database
      final userMap = maps.first;
      final storedPassword = userMap['password'];

      // Check if the entered password matches the stored password
      if (storedPassword == password) {
        return User.fromMap(userMap); // Return the user if password matches
      } else {
        throw Exception(
            'Invalid password'); // Throw an exception if passwords don't match
      }
    } else {
      throw Exception(
          'User not found'); // Throw an exception if the username doesn't exist
    }
  }
}
