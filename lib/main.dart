import 'package:flutter/material.dart';
import 'package:movwe/viewmodels/lobby_viewmodel.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import '../views/login_view.dart';
import '../viewmodels/user_viewmodel.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<LobbyViewModel>(create: (_) => LobbyViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Parkinsans',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 143, 53, 29),
            brightness: Brightness.light, // Light mode
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 233, 154, 142), // AppBar background color
            foregroundColor: Colors.white, // AppBar text/icon color
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 117, 34, 21), // Button background
              foregroundColor: Colors.white, // Button text color
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:Color.fromARGB(255, 117, 34, 21), // TextButton color
            ),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Parkinsans',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 205, 105, 90),
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system, // Automatically switch between light/dark based on dark mode
        home: const LoginView(),
      ),
    );
  }
}