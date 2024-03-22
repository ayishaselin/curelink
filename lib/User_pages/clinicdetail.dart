import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/User_pages/home_page.dart';

class ClinicDetailScreen extends StatelessWidget {
  final Clinic clinic;
  final String clinicId;

  const ClinicDetailScreen({Key? key, required this.clinic, required this.clinicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          clinic.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 1, 101, 252),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            child: Image.network(
              clinic.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${clinic.name}',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Opening Hours: ${clinic.openingHours}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'Place: ${clinic.place}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'Posts:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                 
              ],
            ),
          ),
        ],
      ),
    );
  }
}