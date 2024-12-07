import 'package:flutter/material.dart';
import 'package:movwe/models/movie_model.dart';
import '../viewmodels/movie_viewmodel.dart';

class AddMovieView extends StatefulWidget {
  const AddMovieView({Key? key}) : super(key: key);

  @override
  _AddMovieViewState createState() => _AddMovieViewState();
}

class _AddMovieViewState extends State<AddMovieView> {
  String? _selectedRating;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController genreController = TextEditingController();
    TextEditingController imdbRatingController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Movie'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: genreController,
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            // Dropdown for content rating
            DropdownButton<String>(
              value: _selectedRating,
              hint: const Text('Select Content Rating'),
              items: const [
                DropdownMenuItem(value: 'G', child: Text('G')),
                DropdownMenuItem(value: 'PG', child: Text('PG')),
                DropdownMenuItem(value: 'PG-13', child: Text('PG-13')),
                DropdownMenuItem(value: 'R', child: Text('R')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRating = newValue;
                });
              },
            ),
            TextField(
              controller: imdbRatingController,
              decoration: const InputDecoration(labelText: 'IMDb Rating'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String title = titleController.text.trim();
            String description = descriptionController.text.trim();
            String genre = genreController.text.trim();
            String imdbRating = imdbRatingController.text.trim();

            // Validate IMDb Rating and Content Rating
            if (title.isNotEmpty &&
                description.isNotEmpty &&
                genre.isNotEmpty &&
                _selectedRating != null &&
                imdbRating.isNotEmpty) {
              try {
                double.parse(imdbRating);

                Movie newMovie = Movie(
                  moviePoster: "assets/images/defaultMoviePoster.jpg",
                  title: title,
                  description: description,
                  genre: genre,
                  contentRating: _selectedRating!,
                  IMDbRating: imdbRating,
                );

                // Add the movie to the database (call your viewmodel or database service)
                final movieViewModel = MovieViewModel();
                await movieViewModel.addMovie(newMovie);

                // Close the dialog
                Navigator.of(context).pop();

                // Optionally, show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Movie added successfully!")),
                );
              } catch (e) {
                // Show an error message if IMDb rating is invalid
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please enter a valid IMDb rating.")),
                );
              }
            } else {
              // Show an error if fields are empty or content rating is not selected
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill in all fields.")),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
