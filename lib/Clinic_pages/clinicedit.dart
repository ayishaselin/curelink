 import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Signinup/Signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart'; // Add this import for location

class ClinicProfileEdit extends StatefulWidget {
  const ClinicProfileEdit({Key? key});

  @override
  State<ClinicProfileEdit> createState() => _ClinicProfileEditState();
}

class _ClinicProfileEditState extends State<ClinicProfileEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController timingController = TextEditingController();
   
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String _profilePicUrl = '';
  late Key _circleAvatarKey = UniqueKey();
  String _clinicLocation = ''; 

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signin(userId: '',)));
  }

  Future<void> _saveClinicInformation() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance.collection('CLINIC').doc(userId).update({
          'clinicName': nameController.text,
          'place': placeController.text,
          'openingHours': timingController.text,
          // 'clinicLocation': _clinicLocation, // Store clinic location
        });
        // Optionally, show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Clinic information saved successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      // Handle error
      print('Error saving clinic information: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving clinic information. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          final imageUrl = await _uploadImageToStorage(File(croppedFile.path));
          if (imageUrl != null) {
            setState(() {
              _circleAvatarKey = UniqueKey();
              _profilePicUrl = imageUrl;
            });
          }
        }
      }
    } catch (e) {
      print('Error in _pickAndCropImage: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<CroppedFile?> _cropImage(File imageFile) async {
    final ImageCropper imageCropper = ImageCropper();
    final CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
    );

    return croppedFile;
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = _storage.ref().child('profile_pics/${_auth.currentUser!.uid}.jpg');
      await storageRef.putFile(imageFile);

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

Future<void> _getLocation(BuildContext context) async {
  Location locationService = Location(); // Rename the variable to locationService

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  // Check if location service is enabled
  _serviceEnabled = await locationService.serviceEnabled();
  if (!_serviceEnabled) {
    print("Location service is not enabled. Requesting service...");
    _serviceEnabled = await locationService.requestService();
    if (!_serviceEnabled) {
      print("Location service request denied.");
      return;
    }
  }

  // Check if permissions are granted
  _permissionGranted = await locationService.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    print("Location permission is denied. Requesting permission...");
    _permissionGranted = await locationService.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      print("Location permission request denied.");
      return;
    }
  }

try {
  _locationData = await locationService.getLocation();
  print("Location: ${_locationData.latitude}, ${_locationData.longitude}");

  // Check for nullability and provide default values if needed
  double latitude = _locationData.latitude ?? 0.0;
  double longitude = _locationData.longitude ?? 0.0;

  // Store location data in Firestore as GeoPoint
  await _storeLocation(latitude, longitude);

  // Here you can handle the location data (e.g., update the state, send to backend, etc.)
} catch (locationError) {
  print('Error getting location: $locationError');
}
 catch (locationError) {
    print('Error getting location: $locationError');
  }

  try {
    // Additional error handling for storage can be added if needed
  } catch (storeError) {
    print('Error storing location: $storeError');
  }
}


   

Future<void> _storeLocation(double clinicLatitude, double clinicLongitude) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Replace 'USER' with the collection you created in Firestore
      await FirebaseFirestore.instance.collection('CLINIC').doc(user.uid).update({
        'clinicLocation': GeoPoint(clinicLatitude, clinicLongitude),
      });

      print('Location stored for user ${user.uid} in Firestore');
    } else {
      print('No user is currently signed in.');
    }
  } catch (e) {
    print('Failed to store location: $e');
  }
}


// Function to get the current location
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Clinic Details',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 1, 101, 252),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Clinic name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(labelText: 'Place'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: timingController,
                decoration: const InputDecoration(labelText: 'Give your opening hours accurately'),
                maxLines: 4,
              ),
                
               const SizedBox(height: 16.0),
              // Text above the location button
              const Text(
                'Update Your Location',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),const SizedBox(height: 16.0),
              // Button to allow current location
               ElevatedButton(
              onPressed: () => _getLocation(context),
              child: Text('get current location', style: GoogleFonts.inter(color: Colors.white)),
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
              const SizedBox(height: 16.0),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await _pickAndCropImage();
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            image: _profilePicUrl.isNotEmpty
                                ? CachedNetworkImageProvider(_profilePicUrl)
                                : const AssetImage('images/profile.png') as ImageProvider,
                          ),
                        ),
                      ),
                      if (_profilePicUrl.isEmpty)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: const Icon(
                              Icons.create_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
               
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _saveClinicInformation();
                },
                child: Text('Save', style: GoogleFonts.inter(color: Colors.white)),
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
                  minimumSize: const Size(380, 0),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
 