import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/User_pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';


class ClinicDetailScreen extends StatelessWidget {
  final Clinic clinic;
  final String clinicId;

  const ClinicDetailScreen(
      {Key? key, required this.clinic, required this.clinicId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('POSTS');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          clinic.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 8),
                  Text(
                    'Place: ${clinic.place}',
                    style: const TextStyle(fontSize: 18),
                  ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       Text(
                        'Contact:',
                        style: const TextStyle(fontSize: 18),
                                         ),
                     
                   

               GestureDetector(
  onTap: () {
    launch("tel://${clinic.contact}");
  },
  child: Text(
    ' ${clinic.contact ?? 'No contact available'}',
    style: TextStyle(
      fontSize: 18,
      color: Colors.blue, // Set the text color to blue
    ),
  ),
)

,],),
                  const SizedBox(height: 8),Text(
                    'Opening Hours: ${clinic.openingHours}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                width: double.infinity,
                child: Divider( 
                  thickness: 1,
                  color: Colors.grey, 
                ),
              ),
                  const Text(
                    'Posts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                 StreamBuilder<DocumentSnapshot>(
  stream: postsRef.doc(clinicId).snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    var data = snapshot.data!.data() as Map<String, dynamic>?;

    if (data == null || !data.containsKey('posts')) {
      return const Text('No posts available');
    }

    List<dynamic> posts = data['posts'];

    if (posts.isEmpty) {
      return const Text('No posts available');
    }

    List<Widget> postImages = posts.map<Widget>((post) {
      String imageUrl = post['image_url'];

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(imageUrl),
      );
    }).toList();

    return Column(
      children: postImages,
    );
  },
),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
