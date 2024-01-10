import 'package:flutter/material.dart';
import  'intro1.dart';

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
  return  GestureDetector(
          onTap: () {
            // Navigate to the second page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child:Scaffold(
            backgroundColor: Colors.blue,
       body:SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset('images/logo.png'),
        ),
      ),
    ),
  ),
  );
}

}
