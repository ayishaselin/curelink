import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Doctor_pages/pending.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/location1.dart';
import 'package:flutter_application_1/Admin_pages/admin.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController verificationNumberController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  String userType = 'Default User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete your profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 101, 252),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             
               GestureDetector(
                 
                child: InteractiveViewer(
                  child: Image.asset('images/0031.png'),
                ),
                           ),
              

            
           
        
             const SizedBox(height: 0.0),

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
                    items: <String>['Default User', 'Clinic', 'Doctor']
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
                            controller: registrationNumberController,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom:20),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Get the values from the text controllers
                        String name = nameController.text;
                        String verificationNumber = verificationNumberController.text;
                        String registrationNumber = registrationNumberController.text;
                        // Get the currently signed-in user
                        User? user = FirebaseAuth.instance.currentUser;
                    
                        // Check if the user is not null
                        if (user != null) {
                          try {
                            // Save the profile information to Firestore
                            await FirebaseFirestore.instance.collection('USER').doc(user.uid).set({
                              'Name': name,
                              'userType': userType, // Include userType in Firestore data
                              'verificationNumber': userType == 'Doctor' ? verificationNumber : null,
                              'registrationNumber': userType == 'Clinic' ? registrationNumber : null,
                              'status': 'pending',
                            });
                    
                            // Navigate to the appropriate screen based on userType
                            if (userType == 'Doctor' || userType == 'Clinic') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PendingPage(userId: widget.userId)),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LocationScreen(userId: widget.userId)),
                              );
                            }
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
