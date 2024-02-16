import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigationbar.dart';

import 'drprofile.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key, required String userId});

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
        ]
      ),
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Forum';
      case 1:
        return 'Profile';
       
      default:
        return '';
    }
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return const ForumScreen();
      case 1:
        return  ForumScreen();
       
      default:
        return Container();
    }
  }

}

 