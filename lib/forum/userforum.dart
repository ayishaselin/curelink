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
    String userId = "user123"; // Replace with your user identification logic

    // Save question to Firebase
    await FirebaseFirestore.instance.collection('FORUM').add({
      'question': question,
      'userId': userId,
    });

    // Optionally, you can clear the input field after sending the question
    _questionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Forum'),
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
          // Display the list of questions here if needed
        ],
      ),
    );
  }
}
class Forum {
  String question;
  String answer;
  String userId;

  Forum({required this.question, required this.answer, required this.userId});
}

