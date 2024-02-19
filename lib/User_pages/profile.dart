import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Signinup/Signin.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String _profilePicUrl = '';
  Key _circleAvatarKey = UniqueKey();
  String _fullName = '';
  String _Email = '';
  bool _userDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Call _fetchUserData to fetch user data
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    print("entered function");
    try {
      // Fetch currently authenticated user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Fetch user document using the current user's ID
        final userDoc =
            await _firestore.collection('USER').doc(currentUser.uid).get();

        // Update _fullName and _Email
        setState(() {
          _fullName = userDoc['Name'] ?? 'Name not found';
          _Email = userDoc['Email'] ?? 'Email not found';
        });

        // Check if profilePicUrl field exists before setting _profilePicUrl
        if (userDoc.data()!.containsKey('profilePicUrl')) {
          setState(() {
            _profilePicUrl = userDoc['profilePicUrl'];
          });
        }

        // Set _userDataLoaded to true after fetching data
        setState(() {
          _userDataLoaded = true;
        });
      } else {
        print("No user signed in.");
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
         
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 24.0),
              Text(
                'My Profile',
                style: GoogleFonts.inter(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  await _pickAndCropImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      key: _circleAvatarKey,
                      radius: 50.0,
                      backgroundImage: _profilePicUrl.isNotEmpty
                          ? CachedNetworkImageProvider(_profilePicUrl)
                          : const AssetImage('images/profile.png')
                              as ImageProvider,
                    ),
                    if (_profilePicUrl.isEmpty)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: const Icon(
                            Icons.create_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: <Widget>[
                  Text(
                    _fullName.isNotEmpty ? _fullName : 'Name not found',
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _Email,
                    style: GoogleFonts.inter(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 330.0),
              ElevatedButton(
                onPressed: () async {
                   
             await _auth.signOut();

      // Navigate to the login or sign-up screen
      // You can replace 'LoginScreen' with the screen you want to navigate to after sign-out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin(userId:widget.userId)));
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

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final croppedFile = await _cropImage(File(pickedFile.path));

        if (croppedFile != null) {
          final imageUrl = await _uploadImageToStorage(croppedFile);
          if (imageUrl != null) {
            await _updateProfilePicUrl(widget.userId, imageUrl);

            // Trigger a rebuild by changing the key
            setState(() {
              _circleAvatarKey = UniqueKey();
            });
          }
        }
      }
    } catch (e) {
      print('Error in _pickAndCropImage: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final ImageCropper imageCropper = ImageCropper();
    final croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
    );

    if (croppedFile != null && croppedFile.path != null) {
      return File(croppedFile.path!);
    } else {
      return null;
    }
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final storageRef =
          _storage.ref().child('profile_pics/${widget.userId}.jpg');
      await storageRef.putFile(imageFile);

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateProfilePicUrl(String userId, String? imageUrl) async {
    try {
      if (imageUrl != null) {
        await _firestore.collection('USER').doc(userId).update({
          'profilePicUrl': imageUrl,
        });

        // Update the state to trigger a rebuild
        setState(() {
          _profilePicUrl = imageUrl;
        });
      }
    } catch (e) {
      print('Error updating profile picture URL: $e');
    }
  }
}
