import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;
  final String clinicName;

  Post({required this.userId, required this.clinicName});
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Explore',
        style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false, // Hide the back button
                 
        backgroundColor: Color.fromARGB(255, 1, 101, 252), // Set the background color to blue
         
        
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              width: 150.0,  // Adjust the width to control the size of the logo
              height: 150.0, // Adjust the height to control the size of the logo
               
            ),
          ],
        ),
          
        // Add other AppBar properties as needed
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0), // Add horizontal padding
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
 
        const SizedBox(height: 16.0),
          const Text(
            'Doctor Speciality',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIconButton('Dentist', 'images/dentist.png'),
                buildIconButton('Cardiologist', 'images/cardio.png'),
                buildIconButton('Orthopedist', 'images/ortho.png'),
                buildIconButton('Neurologist', 'images/neuro.png'),
              ],
            ),
          ), const SizedBox(height: 16.0),
          const Text(
            'Clinic Updates',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),]));
  }
}
 Widget buildIconButton(String caption, String imagePath) {
    return InkWell(
      onTap: () {
        // Handle button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 8),
            Text(
              caption,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }