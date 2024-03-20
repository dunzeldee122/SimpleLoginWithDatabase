import 'package:flutter/material.dart';
import 'database.dart';

class RegisterScreen extends StatefulWidget {
  final UserDatabase databaseHelper;
  const RegisterScreen({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  DateTime? _selectedDate; // Nullable DateTime for the selected date

  bool _passwordVisible = false; // Variable for password visibility

  // Map to track field validation errors
  final Map<String, String> _errors = {};

  // Function to validate if a text field is empty
  bool _validateField(String field, TextEditingController? controller, {String? value}) {
    if (_errors.containsKey(field)) {
      return false;
    }
    if (field == 'dob') {
      return _selectedDate != null;
    }
    return controller != null ? controller.text.isNotEmpty : value != null && value.isNotEmpty;
  }

  // Function to validate date of birth
  String? _validateDateOfBirth(DateTime? selectedDate) {
    if (selectedDate == null) return null; // No validation if date is not selected yet

    final currentDate = DateTime.now();
    final tenYearsAgo = currentDate.subtract(const Duration(days: 365 * 10));

    if (selectedDate.isAfter(tenYearsAgo)) {
      return 'You must be at least 10 years old to register';
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Register', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('username') ? 'Field cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('password') ? 'Field cannot be empty' : null,
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('name') ? 'Field cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('email') ? 'Field cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumberController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Phone Number',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('phoneNumber') ? 'Field cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    enabled: false,
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                          : null, // Set initial value to null
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 14.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Date of Birth',
                      hintStyle: const TextStyle(color: Colors.grey),
                      errorText: _validateDateOfBirth(_selectedDate),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Address',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('address') ? 'Field cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _genderController,
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Gender',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: _errors.containsKey('gender') ? 'Field cannot be empty' : null,
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Use initialDate as _selectedDate if not null
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(()
      {
        _selectedDate = picked;
      });
  }

  Future<void> _registerUser() async {
    setState(() {
      // Clear previous errors
      _errors.clear();
    });

    // Validate fields
    if (!_validateField('username', _usernameController) ||
        !_validateField('password', _passwordController) ||
        !_validateField('name', _nameController) ||
        !_validateField('email', _emailController) ||
        !_validateField('phoneNumber', _phoneNumberController) ||
        !_validateField('gender', _genderController) ||
        !_validateField('address', _addressController)) {
      setState(() {
        // Set errors for empty fields
        if (!_validateField('username', _usernameController)) {
          _errors['username'] = 'Field cannot be empty';
        }
        if (!_validateField('password', _passwordController)) {
          _errors['password'] = 'Field cannot be empty';
        }
        if (!_validateField('name', _nameController)) {
          _errors['name'] = 'Field cannot be empty';
        }
        if (!_validateField('email', _emailController)) {
          _errors['email'] = 'Field cannot be empty';
        }
        if (!_validateField('phoneNumber', _phoneNumberController)) {
          _errors['phoneNumber'] = 'Field cannot be empty';
        }
        if (!_validateField('gender', _genderController)) {
          _errors['gender'] = 'Field cannot be empty';
        }
        if (!_validateField('address', _addressController)) {
          _errors['address'] = 'Field cannot be empty';
        }
      });
      return; // Return if any field is empty
    }
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phoneNumber = _phoneNumberController.text;
    final String dob =
        '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}';
    final String gender = _genderController.text;
    final String address = _addressController.text;

    // Check username availability
    final bool isUsernameAvailable = await widget.databaseHelper.isUsernameAvailable(username);
    if (!isUsernameAvailable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Username Not Available'),
            content: Text('The username $username is already taken.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check email availability
    final bool isEmailAvailable = await widget.databaseHelper.isEmailAvailable(email);
    if (!isEmailAvailable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Not Available'),
            content: Text('The email $email is already registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Proceed with user registration
    User newUser = User(
      username: username,
      password: password,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      address: address,
    );

    bool registered = await widget.databaseHelper.registerUser(newUser);

    if (registered) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Complete'),
            content: const Text('You have successfully registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text('User already exists.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
