import 'package:flutter/material.dart';
import 'intro4.dart';

class ForthPage extends StatelessWidget {
  const ForthPage({super.key});

  @override
  Widget build(BuildContext context) {
       return Scaffold(
       body: Stack(
        fit: StackFit.expand,
        children: [ 
          Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('images/doctorintro3.png'),
          const SizedBox(height: 10),
        Text(
            'Engage with our community of experts! Post your health',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(244, 70, 67, 67),
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 0),
        Text(
            'inquiries, and let our qualified doctors provide',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(244, 70, 67, 67),
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 0),
          Text(
            ' personalized insights and answers',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(244, 70, 67, 67),
              fontWeight: FontWeight.normal,
            ),
          ),
        ]
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
                    color: Color.fromARGB(255, 163, 167, 239) ,
                  ),
                ),
                Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 33, 68, 243),
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
      MaterialPageRoute(builder: (context) => FifthPage()),
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