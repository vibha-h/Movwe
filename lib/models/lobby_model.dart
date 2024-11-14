class Lobby {
  int? lobbyId;
  String qrCode;
  int adminId;
  List<int> memberIds;
  List<int> movieIds;
  Map<int, List<int>> userRankings; // Map userId to list of movieIds ranked
  String status;

  Lobby({
    this.lobbyId,
    required this.qrCode,
    required this.adminId,
    this.memberIds = const [],
    this.movieIds = const [],
    this.userRankings = const {},
    this.status = 'OPEN',
  });

  // Convert the Lobby object to a map for the database
  Map<String, dynamic> toMap() {
    return {
      'id': lobbyId,
      'qrCode': qrCode,
      'adminId': adminId,
      'memberIds': memberIds.join(','), // Store list as comma-separated string
      'movieIds': movieIds.join(','),
      'userRankings': _encodeUserRankings(userRankings),
      'status': status,
    };
  }

  // Convert a map to a Lobby object
  factory Lobby.fromMap(Map<String, dynamic> map) {
    return Lobby(
      lobbyId: map['id'],
      qrCode: map['qrCode'],
      adminId: map['adminId'],
      memberIds: _parseIds(map['memberIds']),
      movieIds: _parseIds(map['movieIds']),
      userRankings: _decodeUserRankings(map['userRankings']),
      status: map['status'],
    );
  }

  // Helper to parse a comma-separated string into a list of integers
  static List<int> _parseIds(String? value) {
    if (value == null || value.isEmpty) {
      return [];
    }
    return value.split(',').map((id) => int.tryParse(id) ?? 0).toList();
  }

  // Helper to encode user rankings for database storage
  static String _encodeUserRankings(Map<int, List<int>> rankings) {
    return rankings.entries
        .map((entry) => '${entry.key}:${entry.value.join(',')}')
        .join(';');
  }

  // Helper to decode user rankings from stored string
  static Map<int, List<int>> _decodeUserRankings(String? value) {
    if (value == null || value.isEmpty) {
      return {};
    }
    return Map.fromEntries(value.split(';').map((entry) {
      var parts = entry.split(':');
      var userId = int.tryParse(parts[0]) ?? 0;
      var movieIds =
          parts[1].split(',').map((id) => int.tryParse(id) ?? 0).toList();
      return MapEntry(userId, movieIds);
    }));
  }
}
