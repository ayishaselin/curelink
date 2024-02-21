import 'package:flutter/material.dart';
import 'package:flutter_application_1/Clinic_pages/clinicprofile.dart';
import 'package:flutter_application_1/Clinic_pages/postscreen.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key, required String userId});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
   int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: getBody(myIndex),
      
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: Color.fromARGB(255, 1, 101, 252),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Post',
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
        return 'Post';
      case 1:
        return 'Profile';
       
      default:
        return '';
    }
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return  PostScreen(userId: '',);
      case 1:
        return  ClinicProfile();
       
      default:
        return Container();
    }
  }

}

  
   