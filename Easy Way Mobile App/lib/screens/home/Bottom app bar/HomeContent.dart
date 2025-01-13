import 'package:firebase/screens/QR%20code%20Scanner/scan_code_page.dart';
import 'package:firebase/screens/home/Ordering/shop.dart';
import 'package:firebase/screens/home/maps/normal_map.dart';
import 'package:firebase/screens/home/services.dart';
import 'package:firebase/screens/home/vehicle_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          
          // Start Ride Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            ),
            onPressed: () async {
              DatabaseReference databaseRef = FirebaseDatabase.instance.ref('vehicle_registration');
              User? user = FirebaseAuth.instance.currentUser;
      
              DataSnapshot snapshot = await databaseRef.child(user!.uid).get();
      
              if (!snapshot.exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No vehicle registered. Please register your vehicle first.')),
                );
                return;
              }
      
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HighwayEntranceCodeScanScreen(
                      qrCode: '',
                    ),
                  ));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("START RIDE",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
                SizedBox(width: 10),
                Image.asset(
                  'assets/images/ride.png',
                  width: 40,  // Adjust the width as needed
                  height: 40, // Adjust the height as needed
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 65),
          
          // GridView with 4 buttons
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              _buildGridButton("Vehicle Registrations", 'assets/images/vehicle.png', context),
              _buildGridButton("Ordering", 'assets/images/ordering.png', context),
              _buildGridButton("Road Map", 'assets/images/map.png', context),
              _buildGridButton("Services", 'assets/images/services.png', context),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build individual grid buttons with images
  Widget _buildGridButton(String title, String imagePath, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: () {
        if (title == "Vehicle Registrations") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VehicleRegisterPage()),
          );
        } else if (title == "Ordering") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShoppingCenterPage(),
            ),
          );
        } else if (title == "Road Map") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NormalMapPage(
                qrCode: '',
              ),
            ),
          );
        } else if (title == "Services") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServicePage(),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 55,
            height: 55,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
