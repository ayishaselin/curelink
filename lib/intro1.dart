 import 'package:flutter/material.dart';
import 'package:flutter_application_1/Signin.dart';
 import 'intro2.dart';
 import 'package:google_fonts/google_fonts.dart';
//  import 'package:firebase_core/firebase_core.dart';

 
 

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
       
      body: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image.asset('images/doctorintro.png'),
          ),
           const SizedBox(height: 5),
          const Text(
            'Your Personalized Platform Connecting You to the Perfect Doctor',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            ),
          ),
           const SizedBox(height: 10),
           
             ElevatedButton(
              onPressed: () {
                Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThirdPage()),
    );
              },
              child: const Text('Let\'s Get Started', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
              backgroundColor: const Color.fromARGB(255, 1, 101, 252),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  
                  
                ),
                 shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0), // Rounded edges
              ),minimumSize: const Size(350, 0),

              ),
            ),
             const SizedBox(height: 5),
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
          ]
        ),
    );
  }
}