import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostScreen extends StatefulWidget {
  final String userId;

  const PostScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _selectedImage;
  List<Map<String, dynamic>> _posts = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _fetchPosts();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

Future<void> _fetchPosts() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (_isMounted && currentUser != null) {
      final userId = currentUser.uid;
      print('Fetching posts for userId: $userId');

      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('POSTS')
          .doc(userId)
          .get();

      if (_isMounted) {
        if (userDocSnapshot.exists) {
          setState(() {
            _posts = List<Map<String, dynamic>>.from(userDocSnapshot['posts'] ?? []);
          });
        } else {
          print('User document does not exist for userId: $userId');
        }
      }
    } else {
      print('Invalid user or userId is null.');
    }
  } catch (e) {
    if (_isMounted) {
      print('Error fetching posts: $e');
    }
  }
}



  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      if (_isMounted) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null && _isMounted) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      if (_isMounted) {
        print('Error picking image: $e');
      }
    }
  }

Future<void> _uploadAndSavePost() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  try {
    if (_selectedImage != null && _isMounted) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts/${DateTime.now().toIso8601String()}.jpg');
      await storageRef.putFile(_selectedImage!);

      if (_isMounted) {
        final downloadUrl = await storageRef.getDownloadURL();

        // Create a timestamp on the client side
        final timestamp = DateTime.now();

        // Get the user's document reference
        final userDocRef =
            FirebaseFirestore.instance.collection('POSTS').doc(userId);

        // Update the user's document by adding a new post to the 'posts' array
        await userDocRef.update({
          'posts': FieldValue.arrayUnion([
            {
              'image_url': downloadUrl,
              'timestamp': timestamp,
            }
          ])
        });

        setState(() {
          _selectedImage = null;
        });

        // Fetch posts only if the widget is still mounted
        if (_isMounted) {
          _fetchPosts();
        }
      }
    }
  } catch (e) {
    if (_isMounted) {
      print('Error uploading post: $e');
    }
  }
}


 Widget _buildImagePicker() {
  return SingleChildScrollView(
    child: Column(
      children: [
        for (int index = 0; index < _posts.length; index++)
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Container(
                  height: 350.0,
                  width: 350.0,
                  child: _posts[index]['image_url'] != null &&
                          _posts[index]['image_url'] is String
                      ? Image.network(_posts[index]['image_url'] as String,
                          fit: BoxFit.cover)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _deletePost(index),
                  child: Text('Delete', style: GoogleFonts.inter(color: Colors.white)),
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
                    minimumSize: const Size(200, 0),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16.0),
      ],
    ),
  );
}


Future<void> _deletePost(int index) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userId = currentUser.uid;
      final userDocRef =
          FirebaseFirestore.instance.collection('POSTS').doc(userId);

      // Retrieve the post data to be deleted
      Map<String, dynamic> postData = _posts[index];

      // Remove the post from the list
      setState(() {
        _posts.removeAt(index);
      });

      // Update the user's document by removing the post from the 'posts' array
      await userDocRef.update({
        'posts': FieldValue.arrayRemove([postData])
      });

      // Optionally, you can delete the image from Firebase Storage as well
      // Retrieve the image URL
      final imageUrl = postData['image_url'] as String;
      // Extract the image file name from the URL
      final imageName = imageUrl.split('/').last;
      // Create a reference to the image in Firebase Storage
      final imageRef = FirebaseStorage.instance.ref().child('posts/$imageName');
      // Delete the image from Firebase Storage
      await imageRef.delete();
    }
  } catch (e) {
    print('Error deleting post: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 1, 101, 252),
      ),
      body: Center(
        child: _buildImagePicker(),
      ),
      floatingActionButton: _selectedImage == null
          ? FloatingActionButton(
            
              onPressed: _pickImage,
              tooltip: 'Pick Image',
              child: const Icon(Icons.add_a_photo,color: Color.fromARGB(255, 1, 101, 255), ),
              backgroundColor: Colors.white,
            )
          : FloatingActionButton(
              onPressed: _uploadAndSavePost,
              tooltip: 'Post',
              child: const Icon(Icons.send,color: Color.fromARGB(255, 1, 101, 255),),
            ),
    );
  }
}
