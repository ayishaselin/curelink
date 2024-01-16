 import 'package:flutter/material.dart';
 import 'intro2.dart';

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
              ),minimumSize: const Size(380, 0),

              ),
            ),
             const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
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
            child: const Text(
              'Sign in.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),],
          )],
        ),
    );
  }
}