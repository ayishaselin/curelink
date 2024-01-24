import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

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
          ],
            ),
      ));
  }
}