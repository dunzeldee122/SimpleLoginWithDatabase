import 'package:flutter/material.dart';
import 'database.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  final UserDatabase databaseHelper;
  final User user;
  const HomeScreen({Key? key, required this.databaseHelper, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white, fontSize: 28.0),
          ),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ),
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    child: Image.asset(
                      'assets/fumo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                buildRow(Icons.person_pin, widget.user.name),
                const SizedBox(height: 16.0),
                buildRow(Icons.cake, widget.user.dob),
                const SizedBox(height: 16.0),
                buildRow(Icons.person, widget.user.gender),
                const SizedBox(height: 16.0),
                buildRow(Icons.email, widget.user.email),
                const SizedBox(height: 16.0),
                buildRow(Icons.phone, widget.user.phoneNumber),
                const SizedBox(height: 16.0),
                buildRow(Icons.location_on, widget.user.address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28.0),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 28.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(databaseHelper: widget.databaseHelper),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
