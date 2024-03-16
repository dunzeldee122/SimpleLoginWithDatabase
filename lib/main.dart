//main
import 'package:flutter/material.dart';
import 'database.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart'; // Import HomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserDatabase userDatabase;

  @override
  void initState() {
    super.initState();
    userDatabase = UserDatabase();
    initializeDatabase();
  }

  void initializeDatabase() async {
    await userDatabase.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App with SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => LoginScreen(databaseHelper: userDatabase),
        '/home': (context) => _HomeScreen(databaseHelper: userDatabase),
        '/register': (context) => RegisterScreen(databaseHelper: userDatabase),
      },
      initialRoute: '/login',
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final UserDatabase databaseHelper;

  const _HomeScreen({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: databaseHelper.getUserById(1), // Assuming user with ID 1 is logged in
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            return HomeScreen(databaseHelper: databaseHelper, user: snapshot.data!);
          }
        }
      },
    );
  }
}
