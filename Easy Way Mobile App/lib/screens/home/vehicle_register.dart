import 'package:firebase/services/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:flutter/material.dart';

class VehicleRegisterPage extends StatefulWidget {
  VehicleRegisterPage({super.key});

  @override
  _VehicleRegisterPageState createState() => _VehicleRegisterPageState();
}

class _VehicleRegisterPageState extends State<VehicleRegisterPage> {
  final vehicleModelController = TextEditingController();
  final licensePlateController = TextEditingController();
  final ownerNameController = TextEditingController();
  String? selectedVehicleType;

  final List<String> vehicleTypes = [
    'Car',
    'Truck',
    'Bus',
    'Van',
    'Other'
  ];

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent, // Transparent AppBar
          elevation: 0, // No shadow
        ),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
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
                  "     Vehicle Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "          Enter vehicle details",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey, // Assign form key for validation
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 60),
                              // Vehicle Type Dropdown
                              DropdownButtonFormField<String>(
                                value: selectedVehicleType,
                                decoration: const InputDecoration(
                                  labelText: "Select Vehicle Type",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedVehicleType = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a vehicle type';
                                  }
                                  return null;
                                },
                                items: vehicleTypes.map((String vehicleType) {
                                  return DropdownMenuItem<String>(
                                    value: vehicleType,
                                    child: Text(vehicleType),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 20),

                              // Vehicle Model Field
                              TextFormField(
                                controller: vehicleModelController,
                                decoration: const InputDecoration(
                                  labelText: "Vehicle Model",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the vehicle model';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),

                              // License Plate Field
                              TextFormField(
                                controller: licensePlateController,
                                decoration: const InputDecoration(
                                  labelText: "License Plate Number",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the license plate number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),

                              // Owner Name Field
                              TextFormField(
                                controller: ownerNameController,
                                decoration: const InputDecoration(
                                  labelText: "Owner Name",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the owner name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 40),

                              // Submit Button
                              Container(
                                height: 50,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  color: Colors.orange[900],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      final vehicleType = selectedVehicleType;
                                      final vehicleModel = vehicleModelController.text;
                                      final licensePlate = licensePlateController.text;
                                      final ownerName = ownerNameController.text;

                                      try {
                                      // Access Firebase Realtime Database
                                      DatabaseReference databaseRef = FirebaseDatabase.instance.ref('vehicle_registration');
                                      
                                      // Use current user's ID as the key for the vehicle data
                                      String userId = AuthServices().userID;
                                      
                                      // You can create a new child node under the user's ID to store the vehicle data
                                      await databaseRef.child(userId).set({
                                        'vehicle_type': vehicleType,
                                        'model': vehicleModel,
                                        'license_plate': licensePlate,
                                        'owner_name': ownerName,
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Vehicle registered successfully!"),
                                        ),
                                      );

                                      setState(() {
                                        selectedVehicleType = null;
                                      });
                                      vehicleModelController.clear();
                                      licensePlateController.clear();
                                      ownerNameController.clear();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Failed to register vehicle: $e"),
                                        ),
                                      );
                                    }

                                    }
                                  },
                                  child: Text(
                                    "Register Vehicle",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
