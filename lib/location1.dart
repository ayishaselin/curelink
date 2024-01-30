
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/location.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 25,),
            Text(
              'What is your location?',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              'We need to know your location in order to suggest',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 0.1),
            const Text(
              'nearby services',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () => _getLocation(context),
              child: Text('Allow Location Access', style: GoogleFonts.inter(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                minimumSize: const Size(350, 0),
              ),
            ),
            const SizedBox(height: 25.0),
            TextButton(
              onPressed: () {
                // Handle "Enter Location Manually" button press
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                ' Enter Location Manually',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocation(BuildContext context) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("Location service is not enabled. Requesting service...");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location service request denied.");
        return;
      }
    }

    // Check if permissions are granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print("Location permission is denied. Requesting permission...");
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission request denied.");
        return;
      }
    }

    try {
      _locationData = await location.getLocation();
      print("Location: ${_locationData.latitude}, ${_locationData.longitude}");

      // Store location data in Firestore
      await _storeLocation(_locationData.latitude, _locationData.longitude);

      // Here you can handle the location data (e.g., update the state, send to backend, etc.)
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  Future<void> _storeLocation(latitude,  longitude) async {
    try {
      // Replace 'users' with the collection you created in Firestore
      await FirebaseFirestore.instance.collection('USER').add({
        'location': GeoPoint(latitude, longitude),
      });
      print('Location stored in Firestore');
    } catch (e) {
      print('Failed to store location: $e');
    }
  }
}
