import 'package:firebase/screens/QR%20code%20Scanner/scan_code_page.dart';
import 'package:firebase/screens/home/Navigation%20bar/my_profile_details.dart';
import 'package:firebase/screens/home/Navigation%20bar/paymet_history.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase/screens/authentication/sign_in.dart';
import 'package:firebase/screens/home/Paymnts.dart';
import 'package:firebase/screens/home/Bottom%20app%20bar/weather.dart';
import 'package:firebase/screens/home/maps/normal_map.dart';
import 'package:firebase/screens/home/Bottom%20app%20bar/notification.dart';
import 'package:firebase/screens/home/Bottom%20app%20bar/profile.dart';
import 'package:firebase/screens/home/services.dart';
import 'package:firebase/screens/home/Navigation%20bar/settings.dart';
import 'package:firebase/screens/home/Navigation%20bar/vehicle_details_page.dart';
import 'package:firebase/screens/home/vehicle_register.dart';
import 'package:firebase/screens/home/Ordering/cargills.dart';
import 'package:firebase/screens/home/Ordering/shop.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late DatabaseReference _userRef;
  final AuthServices _auth = AuthServices();

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance
        .ref()
        .child('user_profile'); // Reference to the 'users' node
  }

  Future<String> _getUserName() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch the user ID from Firebase Authentication
      final currentUserId = user!.uid;

      // Get the reference to the 'users' node in Firebase Realtime Database
      final userRef = FirebaseDatabase.instance.ref().child('user_profile');

      // Fetch the user data from Firebase Realtime Database
      final userSnapshot = await userRef.child(currentUserId).get();

      if (userSnapshot.exists) {
        // Fetch the 'name' from the database
        return userSnapshot.child('name').value.toString();
      } else {
        return 'User Name'; // Default value if user data not found
      }
    } else {
      return 'No user signed in'; // Handle case where user is not logged in
    }
  }

  final List<Widget> _pages = [
    HomeContent(),
    WeatherPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900]!,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          "Easy Way",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: FutureBuilder<String>(
          future: _getUserName(), // Fetch user name from Firebase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while fetching
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No user data found'));
            } else {
              String userName = snapshot.data!;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.orange[900]!,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/logo.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userName, // Display the fetched username
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('My Profile'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfileDetails()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.car_crash_outlined),
                    title: const Text('Vehicle Details'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VehicleDetailsPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment_rounded),
                    title: const Text('Payment History'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentHistoryPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: () async {
                      await _auth.signOut();
                      await GoogleSignIn().signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: Container(
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
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
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
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            ),
            onPressed: () async {
              DatabaseReference databaseRef =
                  FirebaseDatabase.instance.ref('vehicle_registration');
              User? user = FirebaseAuth.instance.currentUser;
      
              DataSnapshot snapshot =
                  await databaseRef.child(user!.uid).get();
      
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("START RIDE",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                SizedBox(width: 10),
                Icon(Icons.directions_car, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 65),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              _buildGridButton(
                  "Vehicle Registrations", Icons.directions_car, context),
              _buildGridButton("Ordering", Icons.food_bank_sharp, context),
              _buildGridButton("Road Map", Icons.map, context),
              _buildGridButton("Services", Icons.phone_in_talk, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(String title, IconData icon, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          Icon(icon, color: Colors.black, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
