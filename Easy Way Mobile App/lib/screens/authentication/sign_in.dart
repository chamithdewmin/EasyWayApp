import 'package:firebase/screens/authentication/register.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DatabaseReference users = FirebaseDatabase.instance.ref("user_profile");

  String email = "";
  String password = "";
  String error = "";
  bool _isPasswordVisible = false;
  bool _isLoading = false;  // Loading state

  // Function to handle Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;  // Show loading
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;  // Hide loading if user cancels sign-in
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      DataSnapshot snapshot = await users.child(user!.uid).get();

      // Create new user profile in Firebase if not exists
      if (!snapshot.exists) {
        await users.child(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'phone': '',
          'address': '',
        });
      }
      // Navigate to Home screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;  // Hide loading if an error occurs
        error = "Google sign-in failed: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Function to validate email format
  String? _validateEmail(String? value) {
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  // Function to handle email/password sign-in
  Future<void> _signInWithEmailPassword() async {
    setState(() {
      _isLoading = true;  // Show loading
    });

    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.singInUsingEmailAndPassword(email, password);

      setState(() {
        _isLoading = false;  // Hide loading after result is received
      });

      if (result == null) {
        setState(() {
          error = "Invalid username or password.";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful. Welcome!')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;  // Hide loading if validation fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange[900]!,
                  Colors.orange[800]!,
                  Colors.orange[400]!,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 60),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        const BoxShadow(
                                          color: Color.fromRGBO(255, 95, 27, 0.3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!),
                                            ),
                                          ),
                                          child: TextFormField(
                                            style:
                                                const TextStyle(color: Colors.black),
                                            decoration: const InputDecoration(
                                              hintText: "Email",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                            validator: _validateEmail,
                                            onChanged: (value) {
                                              setState(() {
                                                email = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          child: TextFormField(
                                            obscureText: !_isPasswordVisible,
                                            style:
                                                const TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText: "Password",
                                              hintStyle:
                                                  const TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            validator: (value) => value!.length < 6
                                                ? "Password must be at least 6 characters"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                password = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(error, style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 40),
                                  GestureDetector(
                                    onTap: _signInWithEmailPassword,
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(horizontal: 50),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: _signInWithGoogle,
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account?",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => Register()),
                                          );
                                        },
                                        child: Text(
                                          "Register",
                                          style: TextStyle(
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Display loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[900]!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
