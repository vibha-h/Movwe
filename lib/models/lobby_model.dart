import './user_model.dart';
import './movie_model.dart';

class Lobby {
  String lobbyId;
  String joinCode;
  String qrCode;
  String adminId;
  List<User> memberList;
  List<Movie> movieList;
  Map<User, List<Movie>> userRankings;
  String status;

  Lobby({
    required this.lobbyId,
    required this.joinCode,
    required this.qrCode,
    required this.adminId,
    this.memberList = const [],
    this.movieList = const [],
    this.userRankings = const {},
    this.status = 'OPEN',
  });

  //TODO
  void addMovie(Movie movie){
    movieList.add(movie);
  }

  //TODO
  void removeMovie(Movie movie){
    movieList.remove(movie);
  }

  //TODO
  void addMember(User user){
    memberList.add(user);
    user.joinLobby(this);
  }

  //TODO
  void removeMember(User user){
    memberList.remove(user);
    user.leaveLobby(this);
  }

  //TODO
  void updateStatus(String status){
    this.status = status;
  }

  //TODO
  void finalize(){
    updateStatus("READY");
  }

  //TODO
  void deleteLobby(){
    return;
  }

  //TODO
  List<Movie> calculateAverageRankings(){
    return movieList;
  }

  //TODO
  void addUserRanking(User user, List<Movie> ranking){
    userRankings[user] = ranking;
  }

  //TODO
  void reset(){
    movieList = const [];
    userRankings = const {};
    updateStatus("OPEN");
  }

  //TODO
  Movie selectRandomMovie(){
    return movieList[0];
  }
}