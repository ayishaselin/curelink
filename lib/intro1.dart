 import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
       
      body: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image.asset('images/doctorintro.png'),
          ),
           const SizedBox(height: 5),
          Text(
            'Your Personalized Platform Connecting You to the Perfect Doctor',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(244, 70, 67, 67),
              fontWeight: FontWeight.normal,
            ),
          ),
           const SizedBox(height: 10),
           
             ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: Text('Get Started'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                primary: Color.fromARGB(255, 35, 73, 241), // Adjust the background color as needed
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  
                ),
                 shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0), // Rounded edges
              ),minimumSize: Size(150, 0),

              ),
            ),
             const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            
          
          TextButton(
            onPressed: () {
              // Handle "Sign in" text button press
            },
            child: Text(
              'Sign in.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),],
          )],
        ),
    );
  }
}