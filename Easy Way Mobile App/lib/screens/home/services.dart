import 'package:firebase/screens/home/emergency_number.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase/screens/home/maps/fuel_map.dart';
import 'package:firebase/screens/home/maps/hospital_map.dart';
import 'package:firebase/screens/home/maps/police_map.dart';
import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow from the AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900]!, // Darker orange for the top
              Colors.orange[800]!,
              Colors.orange[400]!, // Lighter orange for the bottom
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "      Services",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "            Explore available services",
              style: TextStyle(color: Colors.white, fontSize: 20),
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
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      _buildServiceCard(
                        context,
                        "Find Fuel Stations",
                        "Locate the nearest fuel stations.",
                        Icons.local_gas_station,
                        () {
                          // Navigate to Fuel Station page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FuelMapPage(qrCode: '',)),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        "Emergency Numbers",
                        "Access important emergency contact numbers.",
                        Icons.phone_in_talk,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EmergencyNumberPage()),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        "Hospitals",
                        "Find nearby hospitals for medical emergencies.",
                        Icons.local_hospital,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HospitalMapPage(qrCode: '',)),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        "Police Stations",
                        "Locate police stations near your location.",
                        Icons.local_police,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PoliceMapPage(qrCode: '',)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a service card with title, description, and icon
  Widget _buildServiceCard(BuildContext context, String title, String description, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed, // Call the passed function when tapped
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
