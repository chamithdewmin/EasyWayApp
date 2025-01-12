import 'package:firebase/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyProfileDetails extends StatefulWidget {
  @override
  _MyProfileDetailsPageState createState() => _MyProfileDetailsPageState();
}

class _MyProfileDetailsPageState extends State<MyProfileDetails> {
  // Variables for storing user profile details
  String name = "";
  String email = "";
  String phoneNumber = "";
  String address = "";

  bool isLoading = true; // Loading state for data fetching

  // Database reference for user profile
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("user_profile");

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  // Function to fetch profile details from Firebase
  Future<void> fetchProfileDetails() async {
    try {
      // Get the current logged-in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is currently logged in.");
        setState(() {
          isLoading = false; // Stop loading if no user is logged in
        });
        return;
      }

      final String userId = user.uid;

      // Listen to database changes
      dbRef.child(userId).onValue.listen((event) {
        final data = event.snapshot.value as Map?;
        if (data != null) {
          setState(() {
            name = data["name"] ?? "Unknown";
            email = data["email"] ?? "Unknown";
            phoneNumber = data["phone"] ?? "Unknown";
            address = data["address"] ?? "Unknown";
            isLoading = false; // Stop loading when data is fetched
          });
        } else {
          // Show error message if no data found for the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No data found for the user.")),
          );
          setState(() {
            isLoading = false; // Stop loading if no data is found
          });
        }
      });
    } catch (e) {
      print("Error fetching profile details: $e");
      setState(() {
        isLoading = false; // Stop loading on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching profile details: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
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
          children: <Widget>[
            Text(
              "     Profile Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "           Here are your profile details",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Container(
                  width: 430,
                  height: 430,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
                          : DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Detail', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Information', style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('Name')),
                                  DataCell(Text(name)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Email')),
                                  DataCell(Text(email)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Phone Number')),
                                  DataCell(Text(phoneNumber)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Address')),
                                  DataCell(Text(address)),
                                ]),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
