 import 'package:flutter/material.dart';
import 'package:flutter_application_1/forum/doctorforum.dart';
import 'package:flutter_application_1/Doctor_pages/drprofile.dart';

class DoctorScreen extends StatefulWidget {
  final String userId;
  final String doctorName;
  final String documentId; // Remove 'question' property as it's not needed

  const DoctorScreen({
    Key? key,
    required this.userId,
    required this.doctorName,
    required this.documentId, required String question,
  }) : super(key: key);

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(myIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return DoctorForumScreen(
           
        );
      case 1:
        return DoctorProfile(userId: widget.userId);
      default:
        return Container();
    }
  }
}
