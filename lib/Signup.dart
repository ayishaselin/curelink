 import 'package:flutter/material.dart';
import 'package:flutter_application_1/terms.dart';
import 'package:flutter_application_1/verify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    bool agreedToTerms = false; // Add this variable to track whether the user agreed to terms

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, statusBarHeight + 20.0, 20.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                'Fill your information below or register',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 0.1),
              const Text(
                'with your social account.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16.0),
              // Username TextField
              Container(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Email',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const TextField(
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
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const TextField(
                        obscureText: true, // Hide the password
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
              const SizedBox(height: 16.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Password',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const TextField(
                        obscureText: true, // Hide the password
                        decoration: InputDecoration(
                          hintText: 'Re-enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0.01),
              Row(
                children: [
                     StatefulBuilder(
                     builder: (context, setState) {
                       return Checkbox(
                        value: agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            // Update the 'agreedToTerms' variable when the checkbox state changes
                            agreedToTerms = value ?? false;
                          });
                        },
                                         );
                     }
                   ),
                  const Text(
                    'Agree with',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Terms()));
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                    ),
                    child: Text(
                      'Terms and conditions',
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
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailVerificationPage(email: 'email',) ));
                  // Handle sign-in logic here
                },
                child: Text('Sign Up', style: GoogleFonts.inter(color: Colors.white)),
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
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    'Or Sign in with',
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Handle click on the image button
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      child: Image.asset(
                        'images/apple.png', // Replace with your image asset path
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Handle click on the image button
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
                  InkWell(
                    onTap: () {
                      // Handle click on the image button
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      child: Image.asset(
                        'images/facebook.png', // Replace with your image asset path
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Already have an account?',
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
      MaterialPageRoute(builder: (context) => const Signin() ));// Handle "Sign in" text button press
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Reduces internal padding to zero
                  minimumSize:
                      Size.zero, // Reduces the minimum size constraints
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // Reduces the tap target size
                ),
                child: Text(
                  'Sign in.',
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
