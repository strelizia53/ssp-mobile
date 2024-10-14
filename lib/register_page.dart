import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();  // Added for validation

  bool isLoading = false;
  String? errorMessage;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {  // Validate form before submission
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final result = await _apiService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _passwordConfirmController.text,
        );

        final token = result['token'];
        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);  // Store token in SharedPreferences
          Navigator.pushReplacementNamed(context, '/home');  // Navigate to home page
        } else {
          throw Exception('Registration failed: No token returned');
        }
      } catch (error) {
        setState(() {
          errorMessage = error.toString();
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Basic Email Validation
  String? _validateEmail(String value) {
    const emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    final regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password Confirmation Validation
  String? _validatePasswordConfirmation(String value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202840),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "ORYX",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 40),

                // Card for form input with a shadow for professionalism
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,  // Add Form key for validation
                      child: Column(
                        children: [
                          // Name Input Field
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.pinkAccent),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: const TextStyle(color: Colors.pinkAccent),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(color: Colors.pinkAccent.withOpacity(0.7)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email Input Field
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.pinkAccent),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.pinkAccent),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.pinkAccent.withOpacity(0.7)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) => _validateEmail(value!),
                          ),
                          const SizedBox(height: 16),

                          // Password Input Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.pinkAccent),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.pinkAccent),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.pinkAccent.withOpacity(0.7)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Input Field
                          TextFormField(
                            controller: _passwordConfirmController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.pinkAccent),
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.pinkAccent),
                              hintText: 'Confirm your password',
                              hintStyle: TextStyle(color: Colors.pinkAccent.withOpacity(0.7)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) => _validatePasswordConfirmation(value!),
                          ),
                          const SizedBox(height: 20),

                          // Error Message
                          if (errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          // Register Button with loading state
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.pinkAccent, // Pink button
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                  : const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Login Text Button to navigate back to login page
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Login here",
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
