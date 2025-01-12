import 'package:firebase/screens/home/home.dart';
import 'package:firebase/screens/home/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase/screens/home/maps/location_provider.dart';

class HospitalMapPage extends StatefulWidget {
  final String qrCode; // Accept QR Code Value

  const HospitalMapPage({super.key, required this.qrCode});

  @override
  State<HospitalMapPage> createState() => _HospitalMapPageState();
}

class _HospitalMapPageState extends State<HospitalMapPage> {
  late GoogleMapController _controller;

  // List of hospitals and highway hospitals in Sri Lanka
  final List<LatLng> _hospitals = [
    // Example hospitals (Replace with actual hospital coordinates)
    LatLng(6.9271, 79.8612), // Colombo National Hospital
    LatLng(6.9776, 80.2311), // Kandy General Hospital
    LatLng(7.2504, 80.6137), // Galle District General Hospital
    LatLng(6.7340, 80.0361), // Anuradhapura Teaching Hospital
    // Add more hospital locations here...
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
              MaterialPageRoute(builder: (context) => ServicePage()),
            );
          },
        ),
        title: const Text("Hospital Map"),
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
                },
                markers: _createHospitalMarkers(), // Add hospital markers
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

  Set<Marker> _createHospitalMarkers() {
    // Create markers for all hospitals
    return _hospitals.map((LatLng position) {
      return Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: 'Hospital',
          snippet: 'Emergency services available here.',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toSet();
  }
}
