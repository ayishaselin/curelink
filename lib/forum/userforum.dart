 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserForumScreen extends StatefulWidget {
  @override
  _UserForumScreenState createState() => _UserForumScreenState();
}

class _UserForumScreenState extends State<UserForumScreen> {
  TextEditingController _questionController = TextEditingController();

  void _sendQuestion() async {
    String question = _questionController.text;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Save question to Firebase
    await FirebaseFirestore.instance.collection('FORUM').add({
      'question': question,
      'userId': userId,
       
      'replies': [], // Initialize replies as an empty array
    });

    // Optionally, you can clear the input field after sending the question
    _questionController.clear();
  }

  Future<String> _getUserName(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(userId).get();
    return userDoc['Name'];
  }

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
          TextField(
            controller: _questionController,
            decoration: InputDecoration(
              hintText: 'Ask a question...',
            ),
          ),
          ElevatedButton(
            onPressed: _sendQuestion,
            child: Text('Send'),
          ),
          Expanded(
            child: _buildQuestionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('FORUM').snapshots(),
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
              Text('Asked by: $userName'), // Display user's name
               
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
}
