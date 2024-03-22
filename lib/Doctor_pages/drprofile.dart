 import 'dart:async';
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
import 'package:location/location.dart';

class DoctorProfileEdit extends StatefulWidget {
  const DoctorProfileEdit({Key? key, required String userId}) : super(key: key);

  @override
  State<DoctorProfileEdit> createState() => _DoctorProfileEditState();
}

class _DoctorProfileEditState extends State<DoctorProfileEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController timingController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String _profilePicUrl = '';
  late Key _circleAvatarKey = UniqueKey();
  String _doctorLocation = '';
  List<bool> _availability = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doctorDoc = await _firestore.collection('DOCTOR').doc(userId).get();

        if (doctorDoc.exists) {
          setState(() {
            nameController.text = doctorDoc['Name'] ?? '';
            specializationController.text = doctorDoc['Specialization'] ?? '';
            bioController.text = doctorDoc['Bio'] ?? '';
            timingController.text = doctorDoc['Timing'] ?? '';
            locationController.text = doctorDoc['Location'] ?? '';
            _profilePicUrl = doctorDoc['ProfilePicUrl'] ?? '';

            List<dynamic>? days = doctorDoc['Availability'];
            if (days != null) {
              for (int i = 0; i < 7; i++) {
                _availability[i] = days.contains(i);
              }
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signin(userId: '')));
  }

  Future<void> _saveDoctorInformation() async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId != null) {
        await _firestore.collection('DOCTOR').doc(userId).update({
          'Name': nameController.text,
          'Specialization': specializationController.text,
          'Bio': bioController.text,
          'Timing': timingController.text,
          'Location':  _doctorLocation,
          'Availability': _availability,
          // Remove 'TimeSlots' update
          // Add more fields as needed
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor information saved successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error saving doctor information: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving doctor information. Please try again.'),
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
          final imageUrl = await _uploadImageToStorage(croppedFile);
          if (imageUrl != null) {
            setState(() {
              _circleAvatarKey = UniqueKey();
              _profilePicUrl = imageUrl;
            });
          }
        }
      }
    } catch (e) {
      print('Error picking and cropping image: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final ImageCropper imageCropper = ImageCropper();
    final CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
    );

    return croppedFile?.path != null ? File(croppedFile!.path!) : null;
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

  Future<String?> _askForLocation() async {
    try {
      Location location = Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          // Location service request denied.
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          // Location permission request denied.
          return null;
        }
      }

      _locationData = await location.getLocation();
      print("Location: ${_locationData.latitude}, ${_locationData.longitude}");
      return "${_locationData.latitude}, ${_locationData.longitude}";
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Doctor Profile',style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await _pickAndCropImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      key: _circleAvatarKey,
                      radius: 50.0,
                      backgroundImage: _profilePicUrl.isNotEmpty
                     ? CachedNetworkImageProvider(_profilePicUrl)
                          : const AssetImage('images/profile.png')
                              as ImageProvider,
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Doctor name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: specializationController,
                decoration: const InputDecoration(labelText: 'Specialization'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 4,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: timingController,
                decoration: const InputDecoration(labelText: 'Give the available timing accurately'),
              ),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 7; i++)
                      Row(
                        children: [
                          Checkbox(
                            value: _availability[i],
                            onChanged: (value) {
                              setState(() {
                                _availability[i] = value!;
                              });
                            },
                          ),
                          Text(_getWeekday(i)),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  String? doctorLocation = await _askForLocation();
                  if (doctorLocation != null) {
                    setState(() {
                      _doctorLocation = doctorLocation;
                    });
                  }
                },
                child: Text('Ask for Location', style: GoogleFonts.inter(color: Colors.white)),
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
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () async {
                  await _saveDoctorInformation();
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signin(userId: '')));
                },
                child: Text('Sign Out', style: GoogleFonts.inter(color: Colors.white)),
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
            ],
          ),
        ),
      ),
    );
  }

  String _getWeekday(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1: 
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }
}