class Movie {
  String movieId;
  String moviePoster;
  String title;
  String description;
  String genre;
  String contentRating;
  String IMDbRating;
  List<String> reviews;
  int numberOfSelections;

  Movie({
    required this.movieId,
    required this.moviePoster,
    required this.title,
    required this.description,
    required this.genre,
    required this.contentRating,
    required this.IMDbRating,
    this.reviews = const [],
    this.numberOfSelections = 0,
  });

  // //TODO
  // void update(Map<String, dynamic> body){
  //   return;
  // }

  // //TODO
  // Movie getMovieDetails(){
  //   return this;
  // }

  // //TODO
  // void addSelection(){
  //   numberOfSelections++;
  // }

  // //TODO
  // void addReview(User user, String review){
  //   return;
  // }
}
