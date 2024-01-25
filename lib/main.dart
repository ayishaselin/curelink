import 'package:flutter/material.dart';
import  'intro1.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
 debugShowCheckedModeBanner: false,
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
    Future.delayed(const Duration(seconds:2), () {
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
