import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/User_pages/clinicdetail.dart';
import 'package:geolocator/geolocator.dart';

import 'drdetail.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List<Clinic> clinics = [];
  List<Doctor> doctors = [];

  LatLng? userLocation;
  String searchText = '';
  // Nullable LatLng

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    fetchClinicDetails();
    fetchDoctorDetails();
  }

  void fetchUserLocation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('USER')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          GeoPoint? locationGeoPoint = userSnapshot['location'];
          if (locationGeoPoint != null) {
            setState(() {
              userLocation =
                  LatLng(locationGeoPoint.latitude, locationGeoPoint.longitude);
            });
          }
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

      List<Clinic> clinicList = clinicSnapshot.docs
          .map((doc) {
            final Map<String, dynamic>? data =
                doc.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('clinicLocation')) {
              GeoPoint? clinicGeoPoint = data['clinicLocation'];
              if (clinicGeoPoint != null) {
                double clinicLatitude = clinicGeoPoint.latitude;
                double clinicLongitude = clinicGeoPoint.longitude;

                return Clinic(
                  name: data['clinicName'] ?? '',
                  location: LatLng(clinicLatitude, clinicLongitude),
                  imagePath: data['_profilePicUrl'] ?? '',
                  place: data['place'] ?? '',
                  openingHours: data['openingHours'] ?? '',
                );
              }
            }
            // Return null if the required fields are missing
            return null;
          })
          .whereType<Clinic>()
          .toList();

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

      List<Doctor> doctorList = doctorSnapshot.docs
          .map((doc) {
            final Map<String, dynamic>? data =
                doc.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('Location')) {
              GeoPoint? doctorGeoPoint = data['Location'];
              if (doctorGeoPoint != null) {
                double doctorLatitude = doctorGeoPoint.latitude;
                double doctorLongitude = doctorGeoPoint.longitude;

                List<dynamic>? availabilityData = data['Availability'];
                List<bool> availability =
                    List<bool>.from(availabilityData ?? []);

                return Doctor(
                  name: data['Name'] ?? '',
                  specialization: data['Specialization'] ?? '',
                  imagePath: data['_profilePicUrl'] ?? '',
                  location: LatLng(doctorLatitude, doctorLongitude),
                  bio: data['Bio'] ?? '',
                  timing: data['Timing'] ?? '',
                  availability: availability,
                );
              }
            }
            return null;
          })
          .whereType<Doctor>()
          .toList();

      setState(() {
        doctors = doctorList;
      });

      // Debug print for doctors list
      print('Doctors: $doctors'); // Check if doctors list is populated
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Clinic> filteredClinics = clinics.where((clinic) {
      return clinic.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
        flexibleSpace: const SizedBox(
          width: 150.0,
          height: 200.0,
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Doctor Speciality',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildIconButton('Dentist', 'images/dentist.png'),
                  buildIconButton('Cardiologist', 'images/cardio.png'),
                  buildIconButton('Orthopedist', 'images/ortho.png'),
                  buildIconButton('Neurologist', 'images/neuro.png'),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Clinics Near You',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search clinics by name',
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              // Wrap the ListView.builder with a Container and set its height
              height: 250.0, // Set the desired height
              child: ListView.builder(
                itemCount: filteredClinics.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  bool isNearby = userLocation != null &&
                      isClinicNearby(filteredClinics[index].location);

                  return Row(
                    children: [
                      buildClinicCard(
                          context, filteredClinics[index], isNearby),
                      const SizedBox(width: 6.0),
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
            // Use ListView.builder directly here
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                bool isNearby = userLocation != null &&
                    isDoctorNearby(doctors[index].location);

                return buildDoctorCard(
                  context,
                  doctors[index],
                  isNearby,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(String caption, String imagePath) {
    return InkWell(
      onTap: () {
        // Handle button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 8),
            Text(
              caption,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClinicCard(BuildContext context, Clinic clinic, bool isNearby) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ClinicDetailScreen(clinic: clinic, clinicId: ''),
          ),
        );
      },
      child: Container(
        width: 250,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                clinic.imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Error loading image');
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    8.0, 8.0, 8.0, 0), // Adjust top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Location: ${clinic.place}',
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
      ),
    );
  }

  Widget buildDoctorCard(BuildContext context, Doctor doctor, bool isNearby) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          elevation: 0, // Set card elevation to 0 to remove its default shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doctor.imagePath,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Specialization: ${doctor.specialization}',
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
        ),
      ),
    );
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

    return distance <= 20000; // 20 kms in meters
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

    return distance <= 20000; // 20 kms in meters
  }
}

class Clinic {
  final String name;
  final LatLng location;
  final String imagePath;
  final String place;
  final String openingHours;

  Clinic({
    required this.name,
    required this.location,
    required this.imagePath,
    required this.place,
    required this.openingHours,
  });
}

class Doctor {
  final String name;
  final String specialization;
  final String imagePath;
  final LatLng location;
  final String bio;
  final String timing;
  final List<bool> availability;

  Doctor({
    required this.name,
    required this.specialization,
    required this.imagePath,
    required this.location,
    required this.bio,
    required this.timing,
    required this.availability,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

class DoctorProfileScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorProfileScreen({Key? key, required this.doctor}) : super(key: key);

  List<String> getDayRanges(List<bool> availability) {
    List<String> dayRanges = [];
    List<String> allDayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    int startIndex = -1;
    int endIndex = -1;

    for (int i = 0; i < availability.length; i++) {
      if (availability[i]) {
        if (startIndex == -1) {
          startIndex = i;
        }
        endIndex = i;
      } else {
        if (startIndex != -1) {
          if (startIndex == endIndex) {
            dayRanges.add(allDayNames[startIndex]);
          } else {
            dayRanges.add('${allDayNames[startIndex]} - ${allDayNames[endIndex]}');
          }
          startIndex = -1;
          endIndex = -1;
        }
      }
    }

    // Check if availability ends with true
    if (startIndex != -1 && endIndex == availability.length - 1) {
      if (startIndex == endIndex) {
        dayRanges.add(allDayNames[startIndex]);
      } else {
        dayRanges.add('${allDayNames[startIndex]} - ${allDayNames[endIndex]}');
      }
    }

    return dayRanges;
  }

  @override
  Widget build(BuildContext context) {
    List<String> dayRanges = getDayRanges(doctor.availability);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${doctor.name}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        doctor.imagePath,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            doctor.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doctor.specialization,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Bio: ${doctor.bio}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Timing: ${doctor.timing}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Availability:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dayRanges.isNotEmpty ? dayRanges.join(', ') : 'Not Available',
                        style: TextStyle(
                          fontSize: 16,
                          color: dayRanges.isNotEmpty ? Colors.green : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}