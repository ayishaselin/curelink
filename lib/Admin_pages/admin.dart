import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Signinup/Signin.dart';
import 'package:flutter_application_1/Doctor_pages/pending.dart';
import 'package:google_fonts/google_fonts.dart';

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
            const SizedBox(height: 8.0,),
            Text(
              'Doctor and Clinic Verification Requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PendingRequestsList(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:20),
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}

class PendingRequestsList extends StatefulWidget {
  @override
  _PendingRequestsListState createState() => _PendingRequestsListState();
}

class _PendingRequestsListState extends State<PendingRequestsList> {
  List<DocumentSnapshot> _requestsList = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USER')
          .where('status', isEqualTo: 'pending')
          .get();
      setState(() {
        _requestsList = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching pending requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _requestsList.isEmpty
        ? Center(child: Text('No pending verification'))
        : ListView.builder(
            itemCount: _requestsList.length,
            itemBuilder: (context, index) {
              var request = _requestsList[index];

              return RequestCard(
                userName: request['Name'],
                verificationNumber: request['verificationNumber'],
                registrationNumber: request['registrationNumber'],
                userType: request['userType'],
                acceptCallback: () => acceptVerification(context, request),
                rejectCallback: () => rejectVerification(context, request['Name']),
              );
            },
          );
  }

  void rejectVerification(BuildContext context, String userName) {
    showSnackBar(context, 'Verification rejected for $userName');
    setState(() {
      _requestsList.removeWhere((request) => request['Name'] == userName);
    });
  }

 Future<void> acceptVerification(BuildContext context, DocumentSnapshot request) async {
  try {
    showSnackBar(context, 'Accepting verification...');

    String userId = request.id;
    String userType = request['userType'] as String;

    // Check if the 'verificationNumber' field is not null before casting it
    String? verificationNumber = request['verificationNumber'] as String?;

    if (userType != 'Doctor' && userType != 'Clinic') {
      throw ArgumentError('Invalid userType: $userType');
    }

    // Move the user to the appropriate collection based on userType
    await moveUserToCollection(userType, userId, request.data()! as Map<String, dynamic>);

    // Update USER document with accepted verification details
    await updateVerificationStatus(userId, userType, verificationNumber ?? '');

    // Remove the accepted request from the list
    setState(() {
      _requestsList.remove(request);
    });

    // If the userType is Clinic, update the role to "Clinic" in the USER document
    if (userType == 'Clinic') {
      await FirebaseFirestore.instance.collection('USER').doc(userId).update({'role': 'Clinic'});
    }

    showSnackBar(context, 'Verification accepted for ${request['Name']}');
  } catch (e) {
    print('Error accepting verification: $e');
    showSnackBar(context, 'Error accepting verification. Please try again.');
  }
}




  Future<void> moveUserToCollection(String userType, String userId, Map<String, dynamic> userData) async {
    late CollectionReference collection; // Initialize with a default value

    if (userType == 'Doctor') {
      collection = FirebaseFirestore.instance.collection('DOCTOR');
    } else if (userType == 'Clinic') {
      collection = FirebaseFirestore.instance.collection('CLINIC');
    } else {
      throw ArgumentError('Invalid userType: $userType'); // Throw an error for invalid userType
    }

    await collection.doc(userId).set(userData);
    await collection.doc(userId).update({'role': userType});
  }

  Future<void> updateVerificationStatus(String userId, String userType, String verificationNumber) async {
    await FirebaseFirestore.instance.collection('USER').doc(userId).update({
      'userType': userType,
      'verificationNumber': verificationNumber,
      'status': 'Accepted',
      'role': userType, // Update the 'role' field in the 'USER' collection
    });
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
  final String? userName;
  final String? verificationNumber;
  final String? registrationNumber;
  final String userType;
  final VoidCallback acceptCallback;
  final VoidCallback rejectCallback;

  const RequestCard({
    Key? key,
    required this.userName,
    required this.verificationNumber,
    required this.registrationNumber,
    required this.userType,
    required this.acceptCallback,
    required this.rejectCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for shadow
      margin: const EdgeInsets.all(10),
      color: Colors.white, // Set background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Set border radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Name: ${userName ?? "N/A"}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Verification Number: ${verificationNumber ?? "N/A"}'),
            Text('Registration Number: ${userType == "Clinic" ? registrationNumber ?? "N/A" : "N/A"}'),
            SizedBox(height: 10),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: acceptCallback,
      child: Text('Accept', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 3, 72, 128), // Background color
        textStyle: TextStyle(color: Colors.white), // Text color
      ),
    ),
    SizedBox(width: 20),
    ElevatedButton(
      onPressed: rejectCallback,
      child: Text('Reject', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 189, 12, 12), // Background color
        textStyle: TextStyle(color: Colors.white), // Text color
      ),
    ),
  ],
),

          ],
        ),
      ),
    );
  }
}
