 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class UserForumScreen extends StatefulWidget {
  @override
  _UserForumScreenState createState() => _UserForumScreenState();
}

class _UserForumScreenState extends State<UserForumScreen> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> filteredQuestions = FirebaseFirestore.instance.collection('FORUM').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Forum',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 1, 101, 252),
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
          Expanded(
            child: _buildQuestionList(),
          ),
           Divider(
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
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendQuestion,
                  child: Text('Send', style: GoogleFonts.inter(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _cancelQuestion,
                  child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Color.fromARGB(255, 1, 101, 252),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
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
          return CircularProgressIndicator();
        }

        var userName = userNameSnapshot.data;

        return ListTile(
          title: Text(question),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asked by: $userName'),

              if (replies.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Replies:'),
                    for (var reply in replies) Text(reply),
                  ],
                ),
            ],
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
