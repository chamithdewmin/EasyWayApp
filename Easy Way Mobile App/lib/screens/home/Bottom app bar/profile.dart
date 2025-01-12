import 'package:firebase/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  String user_id = '';
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  bool isProfileSaved = false;
  bool isLoading = false;
  final AuthServices _authServices = AuthServices();
  late final DatabaseReference userRef;

  late final DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    userRef = FirebaseDatabase.instance
        .ref()
        .child('user_profile')
        .child(_authServices.userID);
    _databaseReference = FirebaseDatabase.instance.ref("user_profile");
        fetchCurrentUser();
        fetchUserData();
        profileExists().then((exists) {
          setState(() {
            isProfileSaved = exists;
          });
        });
      }

  Future<void> fetchCurrentUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setState(() {
          email = currentUser.email ?? '';
        });
      } else {
        print('No user is logged in.');
      }
    } catch (e) {
      print('Error fetching current user: $e');
    }
  }

  Future<bool> profileExists() async {
    final snapshot = await _databaseReference.get();
    return snapshot.exists;
  }

 Future<void> fetchUserData() async {
  try {
    final DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        name = userData['name'] ?? 'N/A';
        phone = userData['phone'] ?? 'N/A';
        address = userData['address'] ?? 'N/A';
      });
    } else {
      showSnackbar('User profile not found.');
    }
  } catch (e) {
    showSnackbar('Error fetching user data: $e');
  }
}

void showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}


  Future<void> saveProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _databaseReference.set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });
      setState(() {
        isProfileSaved = true;
      });
      print('Profile Data Saved');
    } catch (e) {
      print('Error saving profile data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _databaseReference.child(_authServices.userID).update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Data Updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 0),
                const Center(
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                buildTextFormField(
                  label: "Name",
                  isReadOnly: false,
                  initialValue: name,
                  onChanged: (value) => name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextFormField(
                  isReadOnly: true,
                  label: "Email",
                  initialValue: email,
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextFormField(
                  isReadOnly: false,
                  label: "Phone Number",
                  initialValue: phone,
                  onChanged: (value) => phone = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildTextFormField(
                  isReadOnly: false,
                  label: "Address",
                  initialValue: address,
                  onChanged: (value) => address = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.orange[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (isProfileSaved) {
                                updateProfileData();
                              } else {
                                saveProfileData();
                              }
                            }
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isProfileSaved
                                ? "Update Profile"
                                : "Save Changes",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String label,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    required bool isReadOnly,
    String? initialValue,
  }) {
    return TextFormField(
      readOnly: isReadOnly,
      initialValue: initialValue,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
