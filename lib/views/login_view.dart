import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home_view.dart';
import '../viewmodels/user_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
    } else {
      try {
        // authenticate
        await userViewModel.authenticate(username, password);

        // Navigate to the home view
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } catch (e) {
        // If authentication fails, show the error message
        setState(() {
          _errorMessage = 'Invalid username/password combination';
        });
      }
    }
  }

  // Function to show the SignUp Dialog
  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Create Account'),
          content: SignUpForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
              'assets/images/LOGO.jpg',
              width: 150,
              height: 150, 
              ),
              SizedBox(height: 4), // Adjust this value to control how far down the title is
              Text(
                "MovWe",
                style: const TextStyle(
                  fontSize: 45,
                  fontFamily: 'Meddon',
                ),
             ),
            const SizedBox(height: 10), // Space between the title and inputs
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(),
              child: const Text("Login"),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            TextButton(
              onPressed: _showSignUpDialog, // Open the SignUp Dialog
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}

// SignUpForm Widget that will be used in the Dialog
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  void _createAccount() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
    } else if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
    } else {
      // Call createAccount in UserViewModel to add the new user to the database
      bool success = await userViewModel.createAccount(username, password);

      if (success) {
        Navigator.of(context).pop(); // Close the dialog if successful
      } else {
        setState(() {
          _errorMessage = 'Error creating account';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: "Username"),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        TextField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(labelText: "Confirm Password"),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _createAccount,
          child: const Text("Create Account"),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
