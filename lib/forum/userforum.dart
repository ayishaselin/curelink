 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class UserForumScreen extends StatefulWidget {
  const UserForumScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserForumScreenState createState() => _UserForumScreenState();
}

class _UserForumScreenState extends State<UserForumScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> filteredQuestions = FirebaseFirestore.instance.collection('FORUM').snapshots();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'User Forum',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _filterQuestions(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search),
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildQuestionList(),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          const Divider(
            thickness: 1.0,
            color: Colors.grey,
            height: 10.0,
          ),
          // Bottom row with the asking TextField, "Send" button, and "Cancel" button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Ask a question...',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  child: Text('Send',
                      style: GoogleFonts.inter(color: Colors.white)),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _cancelQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.inter(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendQuestion() async {
    String question = _questionController.text;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('FORUM').add({
      'question': question,
      'userId': userId,
      'replies': [],
    });

    _questionController.clear();
  }

  Widget _buildQuestionList() {
    return StreamBuilder(
      stream: filteredQuestions,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _isLoading = true;
          return const SizedBox(); // Return an empty widget while loading
        } else {
          _isLoading = false;
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No questions found'),
          );
        }

        var forumDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: forumDocs.length,
          itemBuilder: (context, index) {
            return _buildListItem(forumDocs[index]);
          },
        );
      },
    );
  }

  Widget _buildListItem(DocumentSnapshot forumDoc) {
    var forumData = forumDoc.data() as Map<String, dynamic>;
    var question = forumData['question'];
    var userId = forumData['userId'];
    var replies = forumData['replies'] ?? [];

    return FutureBuilder(
      future: _getUserName(userId),
      builder: (context, AsyncSnapshot<String> userNameSnapshot) {
        if (userNameSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(); // Return an empty widget while loading
        }

        var userName = userNameSnapshot.data;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$question',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Asked by: $userName',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                if (replies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Replies:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  for (var reply in replies) ...[
                    Text(
                      reply,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getUserName(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(userId).get();
    return userDoc['Name'];
  }

  void _filterQuestions(String keyword) {
    setState(() {
      // Update the StreamBuilder's stream to filter questions based on the keyword
      filteredQuestions = FirebaseFirestore.instance
          .collection('FORUM')
          .orderBy('question')
          .startAt([keyword])
          .endAt([keyword + '\uf8ff'])
          .snapshots();
    });
  }

  void _cancelQuestion() {
    // Clear the asking TextField when the "Cancel" button is pressed
    _questionController.clear();
  }
}
