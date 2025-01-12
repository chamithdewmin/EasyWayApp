import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {


  
  Location _location = Location(); // Initialize _location directly
  Location get location => _location;

  LatLng _locationPosition = LatLng(0.0, 0.0); // Initialize with default position (0.0, 0.0)
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider();

  initialization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if the location service is enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return; // Return if the service is still not enabled
      }
    }

    // Check if the location permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // Return if the permission is not granted
      }
    }

    // Listen for location changes
    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        _locationPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        print(_locationPosition);
        notifyListeners(); // Notify listeners to update UI
      }
    });
  }
}
