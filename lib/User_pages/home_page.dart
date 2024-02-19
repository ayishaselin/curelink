 import 'package:flutter/material.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
        ],
      ),
    );
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
    
  }
    
  }

  
        
      