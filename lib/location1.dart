import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';


class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
           
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Image.asset(
                'images/location.png',
                width: 150,  
                height: 150,  
              ),
              const SizedBox(height: 25,),
              Column(
                children: [
                  Text(
                      'What is your location?',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0,
                      ),
                    ),
                ],
              ),
                const SizedBox(height: 1),
                const Text(
                  'We need to know your location in order to suggest',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 0.1),
                const Text(
                  'nearby services',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Allow Location Access', style: GoogleFonts.inter(color: Colors.white)),
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
                minimumSize: const Size(350, 0),
              ),
            ),
            const SizedBox(height: 25.0),
            TextButton(
                  onPressed: () {
                     
                    // Handle "Sign Up" text button press
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    ' Enter Location Manually',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),

          ],
            ),
      ));
  }
}