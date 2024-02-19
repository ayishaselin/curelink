 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorForumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Forum'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('FORUM').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          // Display the list of questions and answers
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['question']),
                subtitle: Text(
                  data['replies'] != null
                      ? data['replies'].join('\n')
                      : 'No answer yet',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigate to a reply screen or dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorReplyScreen(
                          questionId: docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: Text('Reply'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorReplyScreen extends StatefulWidget {
  final String questionId;

  const DoctorReplyScreen({Key? key, required this.questionId})
      : super(key: key);

  @override
  _DoctorReplyScreenState createState() => _DoctorReplyScreenState();
}

class _DoctorReplyScreenState extends State<DoctorReplyScreen> {
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reply to Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Your Answer'),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Save the answer to the backend using widget.questionId
                await saveAnswer(widget.questionId, answerController.text);

                // Optionally, you can navigate back to the forum screen
                Navigator.pop(context);
              },
              child: Text('Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveAnswer(String questionId, String answer) async {
    try {
      // Update the 'replies' field in the FORUM collection
      await FirebaseFirestore.instance
          .collection('FORUM')
          .doc(questionId)
          .update({
        'replies': FieldValue.arrayUnion([answer]),
      });
    } catch (e) {
      print('Error saving answer: $e');
      // Handle error
    }
  }
}
