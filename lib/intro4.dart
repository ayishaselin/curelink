import 'package:flutter/material.dart';

class FifthPage extends StatelessWidget {
  const FifthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('images/doctorintro4.png'),
              const SizedBox(height: 10),
              const Text(
                'Discover the expertise behind your care. Explore',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(244, 70, 67, 67),
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 0),
              const Text(
                'detailed profiles to learn more about the experienced',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(244, 70, 67, 67),
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 0),
              const Text(
                'doctors dedicated to your well-being',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(244, 70, 67, 67),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Positioned(
            top: 20.0,
            right: 16.0,
            child: TextButton(
              onPressed: () {
                // Handle 'Skip' button press
              },
              child: const Text(
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
                  margin: const EdgeInsets.only(right: 8.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 170, 167, 245),
                  ),
                ),
                Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 170, 167, 245),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 33, 68, 243),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle icon button press
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 36, 45, 222),
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
