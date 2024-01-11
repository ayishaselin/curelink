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
  
class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});
   
   
  
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
   @override
  void initState() {
    super.initState();

    // Navigate to the second page after a short delay
    Future.delayed(Duration(seconds:4), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage()),
      );
    });
  }
   Widget build(BuildContext context) {
   
          return Scaffold(
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
  );

}
}
