import 'package:firebase/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase/screens/QR%20code%20Scanner/scan_exit_code.dart';
import 'package:firebase/screens/home/maps/location_provider.dart';

class NormalMapPage extends StatefulWidget {
  final String qrCode; // Accept QR Code Value

  const NormalMapPage({super.key, required this.qrCode,});

  @override
  State<NormalMapPage> createState() => _NormalMapPageState();
}

class _NormalMapPageState extends State<NormalMapPage> {
  late GoogleMapController _controller;

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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
          },
        ),
        title: const Text("Google Map"),
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
