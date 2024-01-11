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
            Image.asset('images/doctor1.png'),
            const SizedBox(height: 20),
            const  Text(
              'Your Bottom Text',
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),)
          ],
        )
    );
  }
}