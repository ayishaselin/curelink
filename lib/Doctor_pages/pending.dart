 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Doctor_pages/doctorscreen.dart';
import 'package:flutter_application_1/Signinup/Signin.dart';
import 'package:flutter_application_1/Signinup/Signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PendingPage extends StatefulWidget {
  final String userId;

  const PendingPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  String verificationStatus = "Pending"; // Default status, assuming the initial status is "Pending"
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Fetch the user's verification status when the page is initialized
    fetchVerificationStatus();
  }

  Future<void> fetchVerificationStatus() async {
    try {
      // Fetch the user's status from Firestore
      var userSnapshot = await FirebaseFirestore.instance.collection('USER').doc(widget.userId).get();
      var userData = userSnapshot.data() as Map<String, dynamic>;

      // Update the verificationStatus variable based on the fetched status
      setState(() {
        verificationStatus = userData['status'] ?? "Pending";
      });

      // Check if the status is 'Accepted' and navigate to DoctorScreen
      if (verificationStatus == 'Accepted') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorScreen(userId: '', doctorName: '', documentId: '', question: ''),
          ),
        );
      }
    } catch (e) {
      print('Error fetching verification status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Page'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                // Navigate to the login or sign-up screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  Signin(userId: '')),
                );
              },
              child: Text('go to sign in', style: GoogleFonts.inter(color: Colors.white)),
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
                minimumSize: const Size(300, 0),
              ),
            ),
             const SizedBox(height: 16),
            Text(
              'Your Verification is $verificationStatus',
              style: const TextStyle(fontSize: 18),
            ),
            if (verificationStatus == 'Pending') const Text('To check if it is verified, go to the sign-in page'),
            if (verificationStatus == 'Rejected')
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Signup page if the verification is rejected
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text('Go to Signup Page'),
              ),
          ],
        ),
      ),
    );
  }
}
