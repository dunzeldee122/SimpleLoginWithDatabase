//register
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
  late DateTime _selectedDate = DateTime.now();

  bool _passwordVisible = false; //variable for password visibility

  // Map to track field validation errors
  final Map<String, String> _errors = {};

  // Function to validate if a text field is empty
  bool _validateField(String field, TextEditingController? controller, {String? value}) {
    if (_errors.containsKey(field)) {
      return false; // If an error is already set, return false
    }
    return controller != null ? controller.text.isNotEmpty : value != null && value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Register'),
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
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Date of Birth: MM/DD/YYYY',
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorText: _errors.containsKey('dob') ? 'Field cannot be empty' : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'
                              : '',
                          style: const TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Date of Birth',
                style: TextStyle(color: Colors.black, fontSize: 14.0),
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
                  onPressed: () async {
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
                        !_validateField('dob', null, value: _selectedDate.toString()) ||
                        !_validateField('gender', _genderController) || // Validate gender field
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
                        if (!_validateField('dob', null, value: _selectedDate.toString())) {
                          _errors['dob'] = 'Field cannot be empty';
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
                        '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'; // Placeholder for date of birth
                    final String gender = _genderController.text; // Retrieve gender from text field
                    final String address = _addressController.text;

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
                  },
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
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
