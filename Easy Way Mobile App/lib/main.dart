import 'package:firebase/themes/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // If maps are used later
import 'package:firebase/models/UserModel.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/screens/home/maps/location_provider.dart';
import 'package:firebase/easyWay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: null, // Start with null and handle null cases in your app
      value: AuthServices().user, // Stream from AuthServices
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LocationProvider()), // LocationProvider
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:ThemeData.dark(),
          home: const Splash(), // Start with Splash screen
        ),
      ),
    );
  }
}
