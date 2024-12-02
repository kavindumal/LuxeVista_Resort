import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luxevista_resort/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  String _confirmPassword = '';
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = false;
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _register() {
  if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  } 

  Future<void> _saveUserData(String uid) async {
    await _firestore.collection('users').doc(uid).set({
      'fullName': _name,
      'email': _email,
      'homeAddress': 'Not entered yet',
      'cityPostal': 'Not entered yet',
      'paypalEmail': 'Not entered yet',
      'bankCard': 'Not entered yet',
    });
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        // Save user data in Firestore
        await _saveUserData(userCredential.user!.uid);

        // Navigate to login page or dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error occurred')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Image.asset(
                      'assets/images/login_header.png', // Replace with a suitable image in your assets folder
                      height: 150,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phoneNumber = value!;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _password) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _confirmPassword = value!;
                          },
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _createAccount,
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white.withOpacity(0.8),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(fontSize: 18, color: Colors.blue),
                            elevation: 5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                            child: Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
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