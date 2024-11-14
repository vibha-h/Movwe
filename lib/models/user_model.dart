class User {
  int? id;
  String username;
  String password;
  String profilePic;
  List<String> topGenres;
  List<int> lobbyIds;

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
      topGenres: _parseGenres(map['topGenres']),
      lobbyIds: _parseLobbies(map['lobbies']),
    );
  }

  static List<String> _parseGenres(String? value){
    if (value == null || value.isEmpty){
      return [];
    }

    return value.split(',').where((element) => element.isNotEmpty).toList();
  }

  static List<int> _parseLobbies(String? value){
    if (value == null || value.isEmpty){
      return [];
    }

    return value.split(',').map((id) => int.tryParse(id) ?? 0).toList();
  }
}