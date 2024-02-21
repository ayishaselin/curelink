import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String imageUrl;
  final Timestamp timestamp;

  Post({required this.imageUrl, required this.timestamp});
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<void> _fetchPostsFuture;
  late List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPostsFuture = _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('POSTS').get();
      final List<Post> fetchedPosts = [];

      print('Number of documents in POSTS collection: ${querySnapshot.size}');

      for (final doc in querySnapshot.docs) {
        final List<dynamic>? docPosts = doc['posts'];

        if (docPosts != null) {
          print('Number of posts in document ${doc.id}: ${docPosts.length}');

          for (final post in docPosts) {
            final String imageUrl = post['image_url'] ?? '';
            final Timestamp timestamp = post['timestamp'] ?? Timestamp.now();

            fetchedPosts.add(Post(imageUrl: imageUrl, timestamp: timestamp));
            print('Fetched Image URL: $imageUrl');
          }
        }
      }

      setState(() {
        posts = fetchedPosts;
      });

      print('Posts fetched successfully. Number of posts: ${posts.length}');
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Widget _buildImagePicker() {
  Widget imagePicker = Expanded(
    child: ListView(
      children: [
        for (var post in posts)
          Column(
            children: [
              Container(
                height: 350.0,
                width: 350.0,
                child: post.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            print('Error loading image: $error');
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Timestamp: ${post.timestamp.toDate()}',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        const SizedBox(height: 16.0),
      ],
    ),
  );

  // Debug print statements
  _debugPrintPosts();

  return imagePicker;
}



void _debugPrintPosts() {
  for (var post in posts) {
    print('Post: $post');
    // print('Image URL: ${post.imageUrl}');
    }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 1, 101, 252),
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              width: 150.0,
              height: 150.0,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle:
                        TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Doctor Speciality',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIconButton('Dentist', 'images/dentist.png'),
                buildIconButton('Cardiologist', 'images/cardio.png'),
                buildIconButton('Orthopedist', 'images/ortho.png'),
                buildIconButton('Neurologist', 'images/neuro.png'),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Clinic Updates',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          // Use FutureBuilder to handle the async initialization
          FutureBuilder<void>(
            future: _fetchPostsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Display posts from Firestore using _buildImagePicker
                return _buildImagePicker();
              } else {
                // Show a loading indicator while fetching data
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildIconButton(String caption, String imagePath) {
    return InkWell(
      onTap: () {
        // Handle button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 8),
            Text(
              caption,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
