import 'package:flutter/material.dart';
import '../viewmodels/user_viewmodel.dart';

final userViewModel = UserViewModel();

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // You can either use currentUser directly if it's nullable
  // Or store the username here to make the widget reactive to changes
  String? username;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Method to load current user
  Future<void> _loadCurrentUser() async {
    final user = userViewModel.currentUser;
    if (user != null) {
      setState(() {
        username = user.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: username == null
            ? const CircularProgressIndicator() // Show a loading indicator if the username is not yet set
            : Text('Welcome to the Home Page, $username'),
      ),
    );
  }
}