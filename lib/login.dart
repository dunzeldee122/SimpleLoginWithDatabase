import 'package:flutter/material.dart';
import 'database.dart';
import 'home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  final UserDatabase databaseHelper;
  const LoginScreen({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    bool loggedIn = await widget.databaseHelper.loginUser(username, password);

    if (loggedIn) {
      User user = await widget.databaseHelper.getUserByUsername(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(databaseHelper: widget.databaseHelper, user: user), // Pass the user parameter here
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Credentials'),
            content: const Text('Username and password are invalid.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 28.0)),
      ),
      backgroundColor: Colors.green, // Set the background color of the entire app
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.black, fontSize: 28.0),
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.black, fontSize: 28.0),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),//space
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),//widening
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 28.0),//button height
              ),
            ),

            const SizedBox(height: 10),//space
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(databaseHelper: widget.databaseHelper)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50), //widening
              ),
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 28.0),//button height
              ),
            ),

          ],
        ),
      ),
    );
  }
}
