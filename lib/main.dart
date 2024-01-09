import 'package:flutter/material.dart';

main(){
  runApp(MyApp());
   
}
 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightBlue
      ),home: HomeScreen(),
    );
  }
}
  
class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue,
      body:  SafeArea(
        child:  Container(
          width: double.infinity,
          height: double.infinity,
          child:Center(
        child: Text(
          'Curelink',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
          ),
          ),
        ),
      ),
    );
  }
}
