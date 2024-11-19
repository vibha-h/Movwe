class Movie {
  int? movieId;
  String moviePoster;
  String title;
  String description;
  String genre;
  String contentRating;
  String IMDbRating;
  List<String> reviews;
  int numberOfSelections;

  Movie({
    this.movieId,
    required this.moviePoster,
    required this.title,
    required this.description,
    required this.genre,
    required this.contentRating,
    required this.IMDbRating,
    this.reviews = const [],
    this.numberOfSelections = 0,
  });

  // Convert the Movie object to a map for the database
  Map<String, dynamic> toMap() {
    return {
      'moviePoster': moviePoster,
      'title': title,
      'description': description,
      'genre': genre,
      'contentRating': contentRating,
      'IMDbRating': IMDbRating,
      'reviews': reviews.join(','),
      'numberOfSelections': numberOfSelections,
    };
  }

  // Convert a map to a User object
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movieId: map['id'],
      moviePoster: map['moviePoster'],
      title: map['title'],
      description: map['description'],
      genre: map['genre'],
      contentRating: map['contentRating'],
      IMDbRating: map['IMDbRating'],
      reviews: _parseReviews(map['topGenres']),
      numberOfSelections: map['numberOfSelections'],
    );
  }

  static List<String> _parseReviews(String? value) {
    if (value == null || value.isEmpty) {
      return [];
    }

    return value.split(',').where((element) => element.isNotEmpty).toList();
  }
}
