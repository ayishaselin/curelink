import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


import 'home_page.dart';

class SpecializationScreen extends StatelessWidget {
  final String specialization;
  final List<Doctor> doctors;
  final LatLng? userLocation;

  const SpecializationScreen({
    Key? key,
    required this.specialization,
    required this.doctors,
    required this.userLocation,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    List<Doctor> filteredDoctors =
        doctors.where((doctor) => doctor.specialization == specialization).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$specialization',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
      ),
      body: ListView.builder(
        itemCount: filteredDoctors.length,
        itemBuilder: (context, index) {
          bool isNearby = userLocation != null &&
              isDoctorNearby(filteredDoctors[index].location);

          return buildDoctorCard(
            context,
            filteredDoctors[index],
            isNearby,
          );
        },
      ),
    );
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
}
