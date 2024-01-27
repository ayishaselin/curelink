import 'package:flutter/material.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("User Current Location",style: TextStyle(color: Colors.white),),backgroundColor: Color.fromARGB(255, 1, 101, 252),
      ),
    );
  }
}