//  import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Signinup/Signin.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';

// class DoctorProfile extends StatefulWidget {
//   final String userId;
//   const DoctorProfile({Key? key, required this.userId}) : super(key: key);

//   @override
//   State<DoctorProfile> createState() => DoctorProfileState();
// }

// class DoctorProfileState extends State<DoctorProfile> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController specializationController = TextEditingController();
//   final TextEditingController bioController = TextEditingController();
//   final TextEditingController timingController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   String _profilePicUrl = '';
//   Key _circleAvatarKey = UniqueKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Doctor Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   await _pickAndCropImage();
//                 },
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 50.0,
//                       backgroundImage: _profilePicUrl.isNotEmpty
//                           ? CachedNetworkImageProvider(_profilePicUrl)
//                           : const AssetImage('images/profile.png') as ImageProvider,
//                     ),
//                     if (_profilePicUrl.isEmpty)
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color.fromARGB(255, 255, 255, 255),
//                           ),
//                           child: const Icon(
//                             Icons.create_rounded,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               // Name TextField
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//               const SizedBox(height: 16.0),

//               // Specialization TextField
//               TextField(
//                 controller: specializationController,
//                 decoration: InputDecoration(labelText: 'Specialization'),
//               ),
//               const SizedBox(height: 16.0),

//               // Bio TextField
//               TextField(
//                 controller: bioController,
//                 decoration: InputDecoration(labelText: 'Bio'),
//                 maxLines: 4,
//               ),
//               const SizedBox(height: 16.0),

//               // Timing TextField
//               TextField(
//                 controller: timingController,
//                 decoration: InputDecoration(labelText: 'Timing'),
//               ),
//               const SizedBox(height: 16.0),

//               ElevatedButton(
//                 onPressed: () async {
//                   await saveDoctorInformation();
//                 },
//                 child: Text('Save', style: GoogleFonts.inter(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.all(15),
//                   backgroundColor: const Color.fromARGB(255, 1, 101, 252),
//                   textStyle: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(40.0),
//                   ),
//                   minimumSize: const Size(380, 0),
//                 ),
//               ),
//                 const SizedBox(height: 10.0),
//               ElevatedButton(
//                 onPressed: () async {
                   
//              await _auth.signOut();

//       // Navigate to the login or sign-up screen
//       // You can replace 'LoginScreen' with the screen you want to navigate to after sign-out
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Signin(userId:widget.userId)));
//                 },
//                 child: Text('Sign Out', style: GoogleFonts.inter(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.all(15),
//                   backgroundColor: const Color.fromARGB(255, 1, 101, 252),
//                   textStyle: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(40.0),
//                   ),
//                   minimumSize: const Size(380, 0),
//                 ),
//               ), 
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> saveDoctorInformation() async {
//     try {
//       // Get the current user from Firebase Authentication
//       User? currentUser = _auth.currentUser;

//       if (currentUser != null) {
//         // Use the UID of the current user as the document ID in the DOCTOR collection
//         String userId = currentUser.uid;

//         // Get the values from the text controllers
//         String name = nameController.text;
//         String specialization = specializationController.text;
//         String bio = bioController.text;
//         String timing = timingController.text;

//         // Save the doctor information to Firestore in the DOCTOR collection
//         await _firestore.collection('DOCTOR').doc(userId).set({
//           'Name': name,
//           'Specialization': specialization,
//           'Bio': bio,
//           'Timing': timing,
//           // Add other fields as needed
//         });

//         // Optionally, show a success message to the user
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Doctor information saved successfully.'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       } else {
//         print('No user signed in.');
//       }
//     } catch (e) {
//       // Handle error
//       print('Error saving doctor information: $e');
//       // Optionally, show an error message to the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Error saving doctor information. Please try again.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   Future<void> _pickAndCropImage() async {
//     final picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//       if (pickedFile != null) {
//         final croppedFile = await _cropImage(File(pickedFile.path));

//         if (croppedFile != null) {
//           final imageUrl = await _uploadImageToStorage(croppedFile);
//           if (imageUrl != null) {
//             // Trigger a rebuild by changing the key
//             setState(() {
//               _circleAvatarKey = UniqueKey();
//               _profilePicUrl = imageUrl;
//             });
//           }
//         }
//       }
//     } catch (e) {
//       print('Error in _pickAndCropImage: $e');
//       // Optionally, show an error message to the user
//     }
//   }

//   Future<File?> _cropImage(File imageFile) async {
//     final ImageCropper imageCropper = ImageCropper();
//     final croppedFile = await imageCropper.cropImage(
//       sourcePath: imageFile.path,
//       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressFormat: ImageCompressFormat.jpg,
//       compressQuality: 70,
//     );

//     if (croppedFile != null && croppedFile.path != null) {
//       return File(croppedFile.path!);
//     } else {
//       return null;
//     }
//   }

//   Future<String?> _uploadImageToStorage(File imageFile) async {
//     try {
//       final storageRef = _storage.ref().child('profile_pics/${_auth.currentUser!.uid}.jpg');
//       await storageRef.putFile(imageFile);

//       final downloadUrl = await storageRef.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
// }




 import 'dart:async'; // Import required for StreamSubscription
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Clinic_pages/clinicedit.dart'; // Ensure this path is correct
import 'package:flutter_application_1/Signinup/Signin.dart'; // Ensure this path is correct
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key, required String userId}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _ClinicProfileState();
}

class _ClinicProfileState extends State<DoctorProfile> {
  late TextEditingController nameController;
  late TextEditingController placeController;
  late TextEditingController timingController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _profilePicUrl = '';
  String _DrName = '';
  String _place = '';
  String _Timing = '';

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
      _clinicDetailsSubscription = _firestore.collection('DOCTOR').doc(userId).snapshots().listen(
        (clinicDoc) {
          if (clinicDoc.exists) {
            setState(() {
              _DrName = clinicDoc.data()?['Doctor Name'] ?? '';
              _place = clinicDoc.data()?['place'] ?? '';
              _Timing = clinicDoc.data()?['Availavble Timing'] ?? '';
              _profilePicUrl = clinicDoc.data()?['profilePicUrl'] ?? '';
            });
          }
        },
        onError: (e) => print("Error fetching doctor details: $e"),
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
                'Doctor Name: $_DrName',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Place: $_place',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Available Timing: $_Timing',
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
