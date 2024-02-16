import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicData {
  final String image;
  final Timestamp time;

  ClinicData({required this.image, required this.time, required String userId});

  // Factory method to create ClinicData from a Firestore document
  factory ClinicData.fromDocument(DocumentSnapshot doc) {
    return ClinicData(
      image: doc['image'],
      time: doc['time'], userId: '',
    );
  }
}

class ClinicScreen extends StatefulWidget {
  @override
  _ClinicScreenState createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  late Stream<QuerySnapshot> clinicDataStream;

  @override
  void initState() {
    super.initState();
    // Replace 'CLINIC' with your actual Firestore collection name
    clinicDataStream = FirebaseFirestore.instance.collection('CLINIC').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinic Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: clinicDataStream,
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

          // If data is available
          final clinicDataList = snapshot.data?.docs.map((doc) => ClinicData.fromDocument(doc)).toList();

          return ListView.builder(
            itemCount: clinicDataList?.length ?? 0,
            itemBuilder: (context, index) {
              final clinicData = clinicDataList![index];
              print('Image URL: ${clinicData.image}');
              print('Image URL: ${clinicData.time}');
              return ListTile(
                title: Image.network(
                  clinicData.image,
                  height: 100.0, // Adjust the height as needed
                  width: 100.0,  // Adjust the width as needed
                ),
                subtitle: Text('Timestamp: ${clinicData.time.toDate()}'),
              );
            },
          );
        },
      ),
    );
  }
}


