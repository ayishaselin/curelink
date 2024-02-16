import 'dart:io';//will be using when the image comes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/location1.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({super.key, required this.userId});


  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController verificationNumberController=TextEditingController();
   String userType = 'Default User'; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Complete your profile',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 25.0,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Don’t worry, only you can see your personal',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Color.fromARGB(255, 97, 95, 95),
              ),
            ),
            Text(
              'data. No one else will be able to see it.',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Color.fromARGB(255, 97, 95, 95),
              ),
            ),
            const SizedBox(height: 200.0),
        
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 7.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w200),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
        
                  // Phone Number TextField
                  Text(
                    'Phone Number',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 9.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone number',
                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w200),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                    SizedBox(height: 15.0),
                   Text(
                      'User Type',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 9.0),
                    DropdownButton<String>(
                      value: userType,
                      onChanged: (String? newValue) {
                        setState(() {
                          userType = newValue!;
                        });
                      },
                      items: <String>['Default User', 'Clinic', 'Admin', 'Doctor']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
        
                    // Verification Number TextField (Only visible for Doctor)
                    if (userType == 'Doctor')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            'Verification Number',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 9.0),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              controller: verificationNumberController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Enter your verification number',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w200),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (userType == 'Clinic')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            'Registration Number',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 9.0),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              controller: verificationNumberController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Enter your Registration number',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w200),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
        
        
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Get the values from the text controllers
                        String name = nameController.text;
                        String phoneNumber = phoneNumberController.text;
                        String verificationNumber = verificationNumberController.text;
        
                        // Get the currently signed-in user
                        User? user = FirebaseAuth.instance.currentUser;
                         
                        // Check if the user is not null
                        if (user != null) {
                          try {
                            // Save the profile information to Firestore
                            await FirebaseFirestore.instance.collection('USER').doc(user.uid).set({
                              'Name': name,
                              'phoneNumber': phoneNumber,
                              'email': user.email, // Add the user's email
                              'userType': "Default User", // Add the selected user type
                              if (userType == 'Doctor') 'verificationNumber': verificationNumber,
                              // Add other fields as needed
                            });
        
                            // Navigate to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LocationScreen(userId: '')),
                            );
                          } catch (e) {
                            // Handle Firestore save error
                            print('Error saving profile to Firestore: $e');
                            // Optionally, show an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error saving profile information. Please try again.'),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        } else {
                          // Handle the case where user is null
                          print('User is null');
                        }
                      },
                      child: Text('Complete your profile', style: GoogleFonts.inter(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        minimumSize: const Size(380, 0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
      ),
      );
    
  }
}