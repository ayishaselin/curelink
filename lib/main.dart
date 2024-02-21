 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Clinic_pages/clinicscreen.dart';
import 'package:flutter_application_1/Doctor_pages/doctorscreen.dart';
 
import 'package:flutter_application_1/Intro_pages/intro1.dart';
import 'package:flutter_application_1/location1.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: SecondPage(),
    );
  }
}

 

  class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Always show the splash screen for a short delay
    Future.delayed(const Duration(seconds: 2), () {
      // Check if the user is signed in
      User? user = _auth.currentUser;
      if (user != null){
        if (user == 'Default user') {
        // User is already signed in, navigate to LocationScreen
        navigateToLocationScreen();}
        else  if (user == 'Doctor') {
        // User is already signed in, navigate to LocationScreen
        navigateToDoctorScreen();
      } 
      else  if (user == 'Clinic') {
        // User is already signed in, navigate to LocationScreen
        navigateToClinicScreen();}
      }else   {
        // User is not signed in, navigate to SecondPage
        navigateToSecondPage();
      }
  });
  }
  void navigateToLocationScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen(userId: '',)),
    );
  }

  void navigateToDoctorScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DoctorScreen(userId: '', doctorName: '', documentId: '', question: '',)),
    );
  }

  

  void navigateToSecondPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SecondPage()),
    );
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Image.asset('images/logo.png'), // Replace with your splash screen image
          ),
        ),
      ),
    );
  }
  
  void navigateToClinicScreen() { 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ClinicScreen(userId: '',)),
    );
  }
}
