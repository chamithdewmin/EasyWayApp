import 'package:firebase/screens/home/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase/screens/home/maps/location_provider.dart';

class PoliceMapPage extends StatefulWidget {
  final String qrCode; // Accept QR Code Value

  const PoliceMapPage({super.key, required this.qrCode});

  @override
  State<PoliceMapPage> createState() => _PoliceMapPageState();
}

class _PoliceMapPageState extends State<PoliceMapPage> {
  late GoogleMapController _controller;

  // List of police station locations in Sri Lanka (example coordinates)
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Ensure LocationProvider is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).initialization();
    });

    // Define police stations (example coordinates in Sri Lanka)
    _addPoliceStations();
  }

  void _addPoliceStations() {
    // Add markers for different police stations
    _markers.add(Marker(
      markerId: MarkerId('colombo1'),
      position: LatLng(6.9271, 79.8612), // Colombo Fort Police Station
      infoWindow: InfoWindow(title: 'Colombo Fort Police Station'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('kandy'),
      position: LatLng(7.2906, 80.6337), // Kandy Police Station
      infoWindow: InfoWindow(title: 'Kandy Police Station'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('galle'),
      position: LatLng(6.0275, 80.2200), // Galle Police Station
      infoWindow: InfoWindow(title: 'Galle Police Station'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('jaffna'),
      position: LatLng(9.6615, 80.0239), // Jaffna Police Station
      infoWindow: InfoWindow(title: 'Jaffna Police Station'),
    ));

    // Add more stations as needed...
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServicePage(),));
          },
        ),
        title: const Text("Police Map"),
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
                markers: _markers, // Display the police station markers
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
}
