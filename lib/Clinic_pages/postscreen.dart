 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostScreen extends StatefulWidget {
  final String userId;

  const PostScreen({super.key, required this.userId});
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _selectedImage;
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('POSTS').get();

      setState(() {
        _posts = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadAndSavePost() async {
    try {
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child('posts/${DateTime.now().toIso8601String()}.jpg');
        await storageRef.putFile(_selectedImage!);

        final downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('POSTS').add({
          'image_url': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _selectedImage = null;
        });

        _fetchPosts(); // Fetch posts again to include the new one
      }
    } catch (e) {
      print('Error uploading post: $e');
    }
  }

   Widget _buildImagePicker() {
  return SingleChildScrollView(
    child: Column(
      children: [
        if (_selectedImage != null)
          Column(
            children: [
              Image.file(_selectedImage!),
              const SizedBox(height: 16.0),
              FloatingActionButton(
                onPressed: _uploadAndSavePost,
                tooltip: 'Post',
                child: const Icon(Icons.send),
              ),
            ],
          )
        else
          for (var post in _posts)
            Column(
              children: [
                Container(
                  height: 350.0,
                  width: 350.0,
                  child: Image.network(post['image_url'] as String, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Some description or text related to the posted image.',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        const SizedBox(height: 16.0),
        // if (_selectedImage == null)
        //   FloatingActionButton(
        //     onPressed: _pickImage,
        //     tooltip: 'Pick Image',
        //     child: const Icon(Icons.add_a_photo),
        //   ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
      ),
      body: Center(
        child: _buildImagePicker(),
      ),
      floatingActionButton: _selectedImage == null
          ? FloatingActionButton(
              onPressed: _pickImage,
              tooltip: 'Pick Image',
              child: const Icon(Icons.add_a_photo),
            )
          : FloatingActionButton(
              onPressed: _uploadAndSavePost,
              tooltip: 'Post',
              child: const Icon(Icons.send),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PostScreen(userId: '',),
  ));
}
