import 'package:flutter/material.dart';
import 'package:flutter_application_1/User_pages/home_page.dart';

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
                  'Timing: ${doctor.timing}', // Display doctor's timing here
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Availability:',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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