import 'package:firebase/screens/QR%20code%20Scanner/scan_exit_code.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase/screens/home/maps/location_provider.dart';

class MapPage extends StatefulWidget {
  final String qrCode; // Accept QR Code Value

  const MapPage({
    super.key,
    required this.qrCode, required String entranceQrCode,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
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
      if (model.locationPosition != const LatLng(0.0, 0.0)) {
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
            // Next Button
            Positioned(
              bottom: size.height * 0.05,
              left: size.width * 0.1,
              right: size.width * 0.1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HighwayExitCodeScanScreen(
                        entranceQrCode: widget.qrCode, exitQrCode: '', qrCode: '', // Passing the QR code value
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // QR Code White Box
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: Colors.black,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Highway Entrance Location',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              widget.qrCode.isNotEmpty
                                  ? widget.qrCode // Show QR code value
                                  : 'Loading...', // Show "Loading..." when no value
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
