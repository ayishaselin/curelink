import 'package:flutter/material.dart';
import 'intro3.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
       return Scaffold(
       body: Stack(
        fit: StackFit.expand,
        children: [ 
          Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('images/doctorintro2.png'),
        ],
        
      ),
       Positioned(
            top: 20.0,
            right: 16.0,
            child: TextButton(
              onPressed: () {
                // Handle 'Skip' button press
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 172.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 33, 68, 243),
                  ),
                ),
                Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 170, 167, 245),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 163, 167, 239),
                  ),
                ),
                 IconButton(
                  onPressed: () {
                      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForthPage()),
    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 36, 45, 222), // Change icon color to white
                    size: 20.0, // Adjust icon size as needed
                  ),
                ),
              ],
            ),),
  ]),);
  }
}