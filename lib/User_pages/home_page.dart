import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Doctor {
  final String name;
  final String specialization;
  final String imagePath;
  final LatLng location; // Added location field

  Doctor({required this.name, required this.specialization, required this.imagePath, required this.location});
}

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List<Clinic> clinics = [];
  List<Doctor> doctors = [];
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    // Fetch user's location from Firestore when the widget is initialized
    fetchUserLocation();
    // Fetch clinic and doctor details from Firestore
    fetchClinicDetails();
    fetchDoctorDetails();
  }

  void fetchUserLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('USER').doc(user.uid).get();

        if (userSnapshot.exists) {
          GeoPoint locationGeoPoint = userSnapshot['location'] ?? GeoPoint(0.0, 0.0);

          setState(() {
            userLocation = LatLng(locationGeoPoint.latitude, locationGeoPoint.longitude);
            print('User Location: Latitude: ${locationGeoPoint.latitude}, Longitude: ${locationGeoPoint.longitude}');
          });
        } else {
          print('User document does not exist.');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }

  void fetchClinicDetails() async {
    try {
      QuerySnapshot clinicSnapshot =
          await FirebaseFirestore.instance.collection('CLINIC').get();

      List<Clinic> clinicList = clinicSnapshot.docs.map((doc) {
        if (doc.exists) {
          GeoPoint clinicGeoPoint = doc['clinicLocation'] ?? GeoPoint(0.0, 0.0);
          double clinicLatitude = clinicGeoPoint.latitude;
          double clinicLongitude = clinicGeoPoint.longitude;

          print('Clinic Location: Latitude: $clinicLatitude, Longitude: $clinicLongitude');

          return Clinic(
            name: doc['clinicName'] ?? '',
            location: LatLng(clinicLatitude, clinicLongitude),
            imagePath: doc['_profilePicUrl'] ?? '',
          );
        } else {
          print('Clinic document does not exist.');
          return Clinic(name: '', location: LatLng(0.0, 0.0), imagePath: '');
        }
      }).toList();

      setState(() {
        clinics = clinicList;
      });
    } catch (e) {
      print('Error fetching clinic details: $e');
    }
  }

  void fetchDoctorDetails() async {
    try {
      QuerySnapshot doctorSnapshot =
          await FirebaseFirestore.instance.collection('DOCTOR').get();

      List<Doctor> doctorList = doctorSnapshot.docs.map((doc) {
        if (doc.exists) {
          GeoPoint doctorGeoPoint = doc['Location'] ?? GeoPoint(0.0, 0.0);
          double doctorLatitude = doctorGeoPoint.latitude;
          double doctorLongitude = doctorGeoPoint.longitude;

          print('Doctor Location: Latitude: $doctorLatitude, Longitude: $doctorLongitude');

          return Doctor(
            name: doc['Name'] ?? '',
            specialization: doc['Specialization'] ?? '',
            imagePath: doc['_profilePicUrl'] ?? '',
            location: LatLng(doctorLatitude, doctorLongitude),
          );
        } else {
          print('Doctor document does not exist.');
          return Doctor(name: '', specialization: '', imagePath: '', location: LatLng(0.0, 0.0));
        }
      }).toList();

      setState(() {
        doctors = doctorList;
      });
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              width: 150.0,
              height: 200.0,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Clinics Near You',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 200, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                bool isNearby = userLocation != null && isClinicNearby(clinics[index].location);

                return Row(
                  children: [
                    buildClinicCard(context, clinics[index], isNearby),
                    const SizedBox(width: 16.0), // Adjust the width for the gap between cards
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Doctors Near You',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                bool isNearby = userLocation != null && isDoctorNearby(doctors[index].location);

                return buildDoctorCard(context, doctors[index], isNearby);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoctorCard(BuildContext context, Doctor doctor, bool isNearby) {
    return Container(
      width: 250, // Set the width of the card
      margin: const EdgeInsets.symmetric(horizontal: 8), // Adjust the horizontal margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchDoctorImage(doctor.imagePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading image');
                } else {
                  return Image.memory(
                    snapshot.data as Uint8List,
                    height: 40,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Specialization: ${doctor.specialization}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${doctor.location.latitude}, ${doctor.location.longitude}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isNearby ? 'Nearby' : 'Not Nearby',
                    style: TextStyle(
                      fontSize: 14,
                      color: isNearby ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> fetchDoctorImage(String imagePath) async {
    try {
      // Replace 'doctor_images' with the actual folder name in Firebase Storage
      Reference reference = FirebaseStorage.instance.ref().child('doctor_images/$imagePath');
      return await reference.getData();
    } catch (e) {
      print('Error fetching doctor image: $e');
      throw e;
    }
  }

  bool isClinicNearby(LatLng clinicLocation) {
    if (userLocation == null) {
      return false;
    }

    double distance = Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      clinicLocation.latitude,
      clinicLocation.longitude,
    );

    return distance <= 1500; // 1.5 kms in meters
  }

  bool isDoctorNearby(LatLng doctorLocation) {
    if (userLocation == null) {
      return false;
    }

    double distance = Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      doctorLocation.latitude,
      doctorLocation.longitude,
    );

    return distance <= 1500; // 1.5 kms in meters
  }

  Widget buildClinicCard(BuildContext context, Clinic clinic, bool isNearby) {
    return Container(
      width: 250, // Set the width of the card
      margin: const EdgeInsets.symmetric(horizontal: 8), // Adjust the horizontal margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchClinicImage(clinic.imagePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading image');
                } else {
                  return Image.memory(
                    snapshot.data as Uint8List,
                    height: 40,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Location: ${clinic.location.latitude}, ${clinic.location.longitude}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isNearby ? 'Nearby' : 'Not Nearby',
                    style: TextStyle(
                      fontSize: 14,
                      color: isNearby ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> fetchClinicImage(String imagePath) async {
    try {
      // Replace 'clinic_images' with the actual folder name in Firebase Storage
      Reference reference = FirebaseStorage.instance.ref().child('clinic_images/$imagePath');
      return await reference.getData();
    } catch (e) {
      print('Error fetching clinic image: $e');
      throw e;
    }
  }
}

class Clinic {
  final String name;
  final LatLng location;
  final String imagePath;

  Clinic({required this.name, required this.location, required this.imagePath});
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
