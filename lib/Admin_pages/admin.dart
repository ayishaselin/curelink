import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('USER').where('userType', isEqualTo: 'Doctor').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(
              child: Text('No pending doctor verifications.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var doctorData = snapshot.data?.docs[index].data() as Map<String, dynamic>;
              String doctorName = doctorData['Name'] ?? '';
              String verificationNumber = doctorData['verificationNumber'] ?? '';

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Doctor Name: $doctorName'),
                  subtitle: Text('Verification Number: $verificationNumber'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement your logic for accepting the verification
                          // You can update the Firestore document status or perform any other action
                          print('Accepted');
                        },
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Implement your logic for rejecting the verification
                          // You can update the Firestore document status or perform any other action
                          print('Rejected');
                        },
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
