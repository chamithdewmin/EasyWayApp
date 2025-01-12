import 'dart:developer';

import 'package:firebase/screens/home/home.dart';
import 'package:firebase/screens/home/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase/screens/home/maps/location_provider.dart';

class FuelMapPage extends StatefulWidget {
  final String qrCode; // Accept QR Code Value

  const FuelMapPage({super.key, required this.qrCode});

  @override
  State<FuelMapPage> createState() => _FuelMapPageState();
}

class _FuelMapPageState extends State<FuelMapPage> {
  late GoogleMapController _controller;

  // List of fuel stations and service areas across Sri Lanka
  final List<LatLng> _fuelStationsAndServiceAreas = [
    // Southern Expressway (E01)
    LatLng(6.821073, 79.967517), // Kottawa Entry/Exit
    LatLng(6.703271, 79.993963), // Gelanigama Service Area
    LatLng(6.410347, 80.577927), // Kurundugaha Service Area
    LatLng(6.757317, 80.185971), // Matara Service Area
    LatLng(6.226409, 80.015578), // Galle Service Area

    // Outer Circular Expressway (E02)
    LatLng(6.866957, 80.003324), // Kadawatha Entry/Exit
    LatLng(6.798532, 79.998254), // Kaduwela Service Area
    LatLng(6.933920, 80.076173), // Ja-Ela Service Area

    // Colombo-Katunayake Expressway (E03)
    LatLng(7.132385, 79.882549), // Katunayake Service Area

    // Central Expressway (E04 - Partial Completion)
    LatLng(7.254659, 80.572507), // Meerigama Entry/Exit
    LatLng(7.341292, 80.623614), // Kurunegala Service Area
    LatLng(7.389323, 80.703244), // Alawwa Service Area

    // Other Major Routes (National Highways)
    LatLng(7.873054, 80.771797), // Dambulla (A9 Junction)
    LatLng(6.936897, 79.852179), // Wellawatte
    LatLng(6.053519, 80.221096), // Galle
    LatLng(8.311400, 80.403652), // Anuradhapura
    LatLng(9.660713, 80.025501), // Jaffna
    LatLng(7.019226, 80.218765), // Ratnapura
    LatLng(6.932547, 80.563387), // Kandy (A1 Junction)

    // Northern Areas (A9 and others)
    LatLng(9.084367, 80.456963), // Vavuniya Service Area
    LatLng(9.331050, 80.468383), // Kilinochchi
    LatLng(8.931840, 80.429950), // Mannar

    // New Fuel Stations or Service Areas (Example Locations)
    LatLng(7.831521, 80.071356), // Example Service Area 1
    LatLng(6.548734, 80.149215), // Example Service Area 2
  ];

  @override
  void initState() {
    super.initState();
    // Ensure LocationProvider is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).initialization();
    });
  }

  void _centerMapOnUserLocation(LocationProvider locationProvider) {
    if (_controller != null) {
      _controller.animateCamera(
        CameraUpdate.newLatLng(locationProvider.locationPosition),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ServicePage(),
              ),
            );
          },
        ),
        title: const Text("Fuel Map"),
        backgroundColor: Colors.orange,
      ),
      body: googleMapUI(size),
    );
  }

  Widget googleMapUI(Size size) {
    return Consumer<LocationProvider>(builder: (context, model, child) {
      if (model.locationPosition != LatLng(0.0, 0.0)) {
        return Stack(
          children: [
            // Google Map
            Positioned.fill(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: model.locationPosition,
                  zoom: 10.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _addFuelStationMarkers(); // Add fuel station markers
                },
                markers: _createMarkers(), // Add markers
              ),
            ),
          ],
        );
      }

      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Set<Marker> _createMarkers() {
    // Create markers for all fuel stations
    return _fuelStationsAndServiceAreas.map((LatLng position) {
      return Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: 'Fuel Station / Service Area',
          snippet: 'Reliable services available here.',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
    }).toSet();
  }

  void _addFuelStationMarkers() {
    setState(() {
      _createMarkers();
    });
  }
}
