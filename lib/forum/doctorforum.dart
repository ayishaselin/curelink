 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorForumScreen extends StatefulWidget {
  @override
  _DoctorForumScreenState createState() => _DoctorForumScreenState();
}

class _DoctorForumScreenState extends State<DoctorForumScreen> {
  late List<DocumentSnapshot> _docs = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Doctor Forum', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('FORUM').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          _docs = snapshot.data!.docs;

          return AnimatedList(
            key: _listKey,
            initialItemCount: _docs.length,
            itemBuilder: (context, index, animation) {
              Map<String, dynamic> data = _docs[index].data() as Map<String, dynamic>;
              String questionId = _docs[index].id;
              return SizeTransition(
                sizeFactor: animation,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(data['question']),
                    subtitle: Text(
                      data['replies'] != null ? data['replies'].join('\n') : 'No answer yet',
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorReplyScreen(questionId: questionId),
                          ),
                        );
                      },
                      child: Text(
                        'Reply',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(13),
                        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        minimumSize: const Size(90, 0),
                      ),
                    ),
                  ),
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

  const DoctorReplyScreen({Key? key, required this.questionId}) : super(key: key);

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
                await saveAnswer(widget.questionId, answerController.text);
                Navigator.pop(context);
              },
              child: Text('Submit Answer', style: GoogleFonts.inter(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(13),
                backgroundColor: const Color.fromARGB(255, 1, 101, 252),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveAnswer(String questionId, String answer) async {
    try {
      await FirebaseFirestore.instance
          .collection('FORUM')
          .doc(questionId)
          .update({'replies': FieldValue.arrayUnion([answer])});
    } catch (e) {
      print('Error saving answer: $e');
    }
  }
}
