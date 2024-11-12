class User {
  int? id;
  String username;
  String password;
  String profilePic;
  List<String> topGenres;
  List<int> lobbyIds; // List of lobby IDs (foreign keys)

  User({
    this.id,
    required this.username,
    required this.password,
    this.profilePic = '',
    this.topGenres = const [],
    this.lobbyIds = const [],
  });

  // Convert the User object to a map for the database
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'profilePic': profilePic,
      'topGenres': topGenres.join(','),
      'lobbies': lobbyIds.join(','),
    };
  }

  // Convert a map to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      profilePic: map['profilePic'],
      topGenres: (map['topGenres'] as String).split(','),
      lobbyIds: (map['lobbies'] as String).split(',').map((id) => int.parse(id)).toList(),
    );
  }
}