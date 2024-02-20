import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Doctor_pages/doctorscreen.dart';

class PendingPage extends StatefulWidget {
  final String userId;

  const PendingPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  String verificationStatus = "Pending"; // Default status, assuming initial status is "Pending"

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
    } catch (e) {
      print('Error fetching verification status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Verification is $verificationStatus',
              style: TextStyle(fontSize: 18),
            ),
            if (verificationStatus == 'Accepted')
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Doctor Screen or any other screen after verification is accepted
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorScreen(userId: '', doctorName: '', documentId: '', question: '',)),
                  );
                },
                child: Text('Proceed to Doctor Screen'),
              ),
          ],
        ),
      ),
    );
  }
}
