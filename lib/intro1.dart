import 'package:flutter/material.dart';
import 'intro2.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: Text(
              'Let\'s Get Started',
              style: GoogleFonts.nunitoSans(
                // Ensure consistent inherit value
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: const Color.fromARGB(255, 1, 101, 252),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              minimumSize: const Size(380, 0),
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
              const SizedBox(width: 0,),
              TextButton(
                onPressed: () {
                  // Handle "Sign in" text button press
                },
                child: Text(
                  'Sign in.',
                  style: GoogleFonts.nunitoSans(
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
    );
  }
}
