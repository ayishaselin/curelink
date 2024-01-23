import 'dart:io';//will be using when the image comes

import 'package:flutter/material.dart';
import 'package:flutter_application_1/location1.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String? selectedGender;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        
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
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w200),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
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
                    decoration: InputDecoration(
                      hintText: 'phone number',
                      hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w200),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                       Text(
                  'Select your gender',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 9.0),
                  Container(
                  width: double.infinity,  // Ensure that the container takes up the full width

                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    value: selectedGender,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Color.fromARGB(255, 90, 88, 88)),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                    items: <String>['Male', 'Female', 'Others']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                 const SizedBox(height: 40.0),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Location()));
                  // Handle sign-in logic here
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
      ))],
        ));
                      
           
            }
}