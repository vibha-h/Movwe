import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  final Function(String) onSearch;
  

  const SearchView({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                onSearch(query); //call the search function in the view_model
              },
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: MovieResultsList(),
          ),
        ],
      ),
    );
  }
}

class MovieResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//REPLACE
    return ListView.builder(
      itemCount: 10, //replace with actual data length
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text('Movie $index'),
          subtitle: Text('Movie description'),
          onTap: () {
            //  movie selection
          },
        );
      },
    );
  }
}