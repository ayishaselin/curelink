import 'package:cloud_firestore/cloud_firestore.dart';

class ForumService {
  static CollectionReference forumCollection = FirebaseFirestore.instance.collection('forum');

  static Future<String> submitUserQuestion(String userId, String question) async {
    DocumentReference<Object?> documentReference = await forumCollection.add({
      'userQuestion': {
        'userId': userId,
        'question': question,
      },
    });
    return documentReference.id;
  }

  static Future<String> getDocumentId(String userId, String question) async {
    QuerySnapshot<Object?> snapshot = await forumCollection
        .where('userQuestion.userId', isEqualTo: userId)
        .where('userQuestion.question', isEqualTo: question)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      throw Exception('Document ID not found');
    }
  }

  static Stream<QuerySnapshot<Object?>> getForumStream() {
    return forumCollection.snapshots();
  }

  static submitDoctorAnswer(String documentId, String doctorId, String answer) async {
    await forumCollection.doc(documentId).update({
      'doctorAnswer': {
        'doctorId': doctorId,
        'answer': answer,
      },
    });
  }
}
