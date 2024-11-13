import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../viewmodels/user_viewmodel.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserViewModel>( // Explicitly specify the type parameter
      create: (_) => UserViewModel(),  // Provide UserViewModel as a singleton
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<UserViewModel>(  // Use Consumer to reactively get current user
          builder: (context, userViewModel, child) {
            // Check if the currentUser is set (logged in)
            if (userViewModel.currentUser != null) {
              // If logged in, navigate to HomeView
              return const HomeView();
            } else {
              // If not logged in, stay on LoginView
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}