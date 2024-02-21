 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Signinup/Signin.dart';
import 'package:flutter_application_1/Doctor_pages/pending.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 1, 101, 252),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Doctor and Clinic Verification Requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PendingRequestsList(),
            ),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signin(userId: '')),
                );
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
    );
  }
}

class PendingRequestsList extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('USER')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          showErrorSnackBar(context, 'Error: ${snapshot.error}');
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No pending requests.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var request = snapshot.data!.docs[index];

            return RequestCard(
              userName: request['Name'],
              verificationNumber: request['verificationNumber'],
              registrationNumber: request['registrationNumber'],
              userType: request['userType'],
              acceptCallback: () => acceptVerification(
                context,
                request['Name'],
                request['verificationNumber'],
                request['registrationNumber'],
                request['userType'],
              ),
              rejectCallback: () => rejectVerification(context, request['Name']),
            );
          },
        );
      },
    );
  }

  void showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
      ),
    );
  }

    Future<void> acceptVerification(
  BuildContext context,
  String userName,
  String verificationNumber,
  String? registrationNumber,
  String userType,
) async {
  try {
    showSnackBar(context, 'Accepting verification...');

    await FirebaseFirestore.instance
        .collection('USER')
        .where('Name', isEqualTo: userName)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        String userId = snapshot.docs.first.id;
        var userData = snapshot.docs.first.data() as Map<String, dynamic>;

        print('Original userType: ${userData['userType']}');

        // Move the user to the appropriate collection based on userType
        if (userType == 'Doctor') {
          await FirebaseFirestore.instance
              .collection('DOCTOR')
              .doc(userId)
              .set(userData);
          
          // Set the 'role' field in the 'DOCTOR' collection
          await FirebaseFirestore.instance
              .collection('DOCTOR')
              .doc(userId)
              .update({'role': 'Doctor'});
        } else if (userType == 'Clinic') {
          await FirebaseFirestore.instance
              .collection('CLINIC')
              .doc(userId)
              .set(userData);
          
          // Set the 'role' field in the 'CLINIC' collection
          await FirebaseFirestore.instance
              .collection('CLINIC')
              .doc(userId)
              .update({'role': 'Clinic'});
        }

        // Update USER document with accepted verification details
        await FirebaseFirestore.instance.collection('USER').doc(userId).update({
          'userType': userType,
          'verificationNumber': verificationNumber,
          'status': 'Accepted',
          'role': userType == 'Doctor' ? 'Doctor' : 'Clinic', // Update the 'role' field in the 'USER' collection
        });
        if (userType == 'Doctor') {
          await FirebaseFirestore.instance
              .collection('DOCTOR')
              .doc(userId)
              .set(userData);
        } else if (userType == 'Clinic') {
          await FirebaseFirestore.instance
              .collection('CLINIC')
              .doc(userId)
              .set(userData);

        print('Updated userType: $userType');

        showSnackBar(context, 'Verification accepted for $userName');
      }
  }});
  } catch (e) {
    print('Error accepting verification: $e');
    showSnackBar(context, 'Error accepting verification. Please try again.');
  }
}


  void rejectVerification(BuildContext context, String userName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PendingPage(userId: '')),
    );
    showSnackBar(context, 'Verification rejected for $userName');
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String userName;
  final String verificationNumber;
  final String? registrationNumber;
  final String userType;
  final VoidCallback acceptCallback;
  final VoidCallback rejectCallback;

  const RequestCard({
    Key? key,
    required this.userName,
    required this.verificationNumber,
    required this.acceptCallback,
    required this.rejectCallback,
    required this.userType,
    this.registrationNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Name: $userName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
             
            Text('Verification Number: $verificationNumber'),
            
              Text('Registration Number: $registrationNumber'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: acceptCallback,
                  child: Text('Accept'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: rejectCallback,
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
