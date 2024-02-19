

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Clinic_pages/clinicscreen.dart';
import 'package:flutter_application_1/Signinup/Signup.dart';
import 'package:flutter_application_1/Admin_pages/admin.dart';
 
import 'package:flutter_application_1/User_pages/navigationbar.dart';
import 'package:flutter_application_1/User_pages/profile.dart';
import 'package:flutter_application_1/Signinup/profilecomp.dart';
import 'package:flutter_application_1/location1.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Doctor_pages/doctorscreen.dart';
 
 


class Signin extends StatelessWidget {
  final String userId;
  Signin({Key? key, required this.userId});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

   Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
  try {
    if (email == 'admin' && password == '123456') {
      // Navigate to the Admin page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
      return;
    }

    // If not admin credentials, proceed with regular sign-in
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // User signed in successfully, get user information
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      // Get the user's email and UID
      String userEmail = user.email ?? '';
      String userId = user.uid;

      // Check the user type
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('USER').doc(userId).get();
      String userType = userSnapshot['userType'] ?? '';

      // Navigate based on the user type
      if (userType == 'Doctor') {
        // Navigate to the DoctorScreen
          DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance.collection('DOCTOR').doc(userId).get();
      String doctorName = doctorSnapshot['Name'] ?? 'Unknown Doctor';

      // Navigate to the DoctorScreen with the fetched doctor's name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorScreen(userId: userId, doctorName: doctorName,question: '',documentId: '//',)),
      );
    }
 else {
        // Navigate to the LocationScreen for other user types
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationScreen(userId: userId)),
        );
      }
    }
  } catch (e) {
    // Handle sign-in errors
    print(e.toString());

    // Display a snackbar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign-in failed: ${e.toString()}'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


  //apple signup
    
//google signup
 //google signup
//google signup
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Get the signed-in user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      // Get the user's email and UID
      String userEmail = user.email ?? '';
      String userId = user.uid;

      // Store the email in the Firestore collection with the UID as document ID
      await FirebaseFirestore.instance.collection('USER').doc(userId).set({
        'Email': userEmail,
        // Add other fields as needed
      });

      // Navigate to the Profile screen
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  
                  userId: userId,
                  
                ),
              ),
            );
    } else {
      // Handle the case where user is null
      print('User is null');
    }
  } catch (e) {
    print(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Google sign-in failed: ${e.toString()}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}





  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, statusBarHeight + 20.0, 20.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Hi, Welcome back, you’ve been missed',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 70.0),

              // Email TextField
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Password TextField
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),

              // Forgot Password TextButton
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle "Forgot Password?" text button press
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.01,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Sign In ElevatedButton
              ElevatedButton(
                onPressed: () async {
                  // Call the signInWithEmailAndPassword method
                  await signInWithEmailAndPassword(context, _emailController.text, _passwordController.text);
                  //  Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Navigation()),
                  //     );
                },
                child: Text('Sign In', style: GoogleFonts.inter(color: Colors.white)),
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
              const SizedBox(height: 35),

              // Or Sign in with Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    ' Or Sign in with ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // Social Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   
                  InkWell(
                    onTap: () async{
                       await signInWithGoogle(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      child: Image.asset(
                        'images/google.png', // Replace with your image asset path
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  
                ]
              ),
              const SizedBox(height: 35),

              // Don't have an account? Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                      // Handle "Sign Up" text button press
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      ' Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
