import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Signinup/Signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  final String doctorName;
  final String verificationNumber;

  const AdminPage({Key? key, required this.doctorName, required this.verificationNumber})
      : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
   final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Doctor Verification Request',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Doctor Name: ${widget.doctorName}'),
            subtitle: Text('Verification Number: ${widget.verificationNumber}'),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  acceptVerification(widget.doctorName, widget.verificationNumber);
                },
                child: Text('Accept'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  rejectVerification(widget.doctorName);
                },
                child: Text('Reject'),
              ),
               
            ],
          ),
          ElevatedButton(
                onPressed: () async {
                   
             await _auth.signOut();

      // Navigate to the login or sign-up screen
      // You can replace 'LoginScreen' with the screen you want to navigate to after sign-out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin(userId: '',)));
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
      
    );
  }

  void acceptVerification(String doctorName, String verificationNumber) async {
    try {
      // Update Firestore document with userType = "Doctor"
      await FirebaseFirestore.instance.collection('USER').where('Name', isEqualTo: doctorName).get().then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          String userId = snapshot.docs.first.id;
          FirebaseFirestore.instance.collection('USER').doc(userId).update({
            'userType': 'Doctor',
            'verificationNumber': verificationNumber,
          });
          // Optionally, notify the user about the acceptance
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification accepted for $doctorName'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    } catch (e) {
      // Handle update errors
      print('Error accepting verification: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting verification. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void rejectVerification(String doctorName) {
    // Handle the logic for rejecting verification (optional)
    // You may want to notify the user about the rejection
    // Optionally, you can navigate to another page or show a rejection message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification rejected for $doctorName'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
