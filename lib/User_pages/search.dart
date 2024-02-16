import 'package:flutter/material.dart';

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
        const SizedBox(height: 16.0)]));
  }
}