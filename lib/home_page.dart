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
                 
        backgroundColor: Colors.blue, // Set the background color to blue
         
        
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              width: 150.0,  // Adjust the width to control the size of the logo
              height: 150.0, // Adjust the height to control the size of the logo
              child: Image.asset(
                'images/logo.png',
                 
              ),
            ),
          ],
        ),
          
        // Add other AppBar properties as needed
      ),
       body: Column(
        children: [Container(
            
                     
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child:  TextField(
                        
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                        ),
                      ),
        )],
      ) //dd other AppBar properties as needed
      );
       
      // Add the rest of your widget tree here
    
  }
}
