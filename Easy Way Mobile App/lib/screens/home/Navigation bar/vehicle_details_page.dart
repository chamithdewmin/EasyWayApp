import 'package:firebase/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class VehicleDetailsPage extends StatefulWidget {
  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  // Variables to hold vehicle details
  String vehicleType = "";
  String vehicleModel = "";
  String registrationNumber = "";
  String ownerName = "";

  bool isLoading = true; // Loading state indicator

  // Database reference
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("vehicle_registration");

  @override
  void initState() {
    super.initState();
    fetchVehicleDetails();
  }

  Future<void> fetchVehicleDetails() async {
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
            vehicleType = data["vehicle_type"] ?? "Unknown";
            vehicleModel = data["model"] ?? "Unknown";
            registrationNumber = data["license_plate"] ?? "Unknown";
            ownerName = data["owner_name"] ?? "Unknown";
            isLoading = false; // Stop loading when data is fetched
          });
        } else {
          print("No data found for the user.");
          setState(() {
            isLoading = false; // Stop loading if no data is found
          });
        }
      });
    } catch (e) {
      print("Error fetching vehicle details: $e");
      setState(() {
        isLoading = false; // Stop loading on error
      });
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
              "     Vehicle Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "           Here are the vehicle details",
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
                          ? Center(child: CircularProgressIndicator()) // Show loading spinner
                          : DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Detail', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Information', style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('Vehicle Type')),
                                  DataCell(Text(vehicleType)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Vehicle Model')),
                                  DataCell(Text(vehicleModel)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Registration Number')),
                                  DataCell(Text(registrationNumber)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Owner Name')),
                                  DataCell(Text(ownerName)),
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
