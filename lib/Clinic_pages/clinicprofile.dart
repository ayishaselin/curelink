 import 'dart:async'; // Import required for StreamSubscription
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Clinic_pages/clinicedit.dart'; // Ensure this path is correct
import 'package:flutter_application_1/Signinup/Signin.dart'; // Ensure this path is correct
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClinicProfile extends StatefulWidget {
  const ClinicProfile({Key? key}) : super(key: key);

  @override
  State<ClinicProfile> createState() => _ClinicProfileState();
}

class _ClinicProfileState extends State<ClinicProfile> {
  late TextEditingController nameController;
  late TextEditingController placeController;
  late TextEditingController timingController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _profilePicUrl = '';
  String _clinicName = '';
  String _place = '';
  String _openingHours = '';

  StreamSubscription<DocumentSnapshot>? _clinicDetailsSubscription;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    placeController = TextEditingController();
    timingController = TextEditingController();
    _fetchClinicDetails(); // Subscribe to clinic details updates
  }

  @override
  void dispose() {
    _clinicDetailsSubscription?.cancel(); // Cancel the subscription
    super.dispose();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signin(userId: '',)));
  }

  void _fetchClinicDetails() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _clinicDetailsSubscription = _firestore.collection('CLINIC').doc(userId).snapshots().listen(
        (clinicDoc) {
          if (clinicDoc.exists) {
            setState(() {
              _clinicName = clinicDoc.data()?['clinicName'] ?? '';
              _place = clinicDoc.data()?['place'] ?? '';
              _openingHours = clinicDoc.data()?['openingHours'] ?? '';
              _profilePicUrl = clinicDoc.data()?['profilePicUrl'] ?? '';
            });
          }
        },
        onError: (e) => print("Error fetching clinic details: $e"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clinic Name: $_clinicName',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Place: $_place',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Opening Hours: $_openingHours',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Container(
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
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClinicProfileEdit()), // Ensure this navigation is correct
                  );
                },
                child: Text('Edit', style: GoogleFonts.inter(color: Colors.white)),
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
              ElevatedButton(
                onPressed: () async {
                  await _signOut();
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
}