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
}