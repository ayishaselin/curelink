import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Signinup/profilecomp.dart';
import 'package:flutter_application_1/location1.dart';
import 'package:flutter_application_1/terms.dart';
import 'package:flutter_application_1/verify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  bool showSpinner = false;
  bool agreedToTerms = false;

 @override
  void initState() {
    super.initState();
    
  }



  // Function to create a new user and store user data in Firestore
  Future<void> signUpAndStoreUserData(BuildContext context) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
       String userId = userCredential.user!.uid;


      // Store additional user data in Firestore
      await _firestore.collection('USER').doc(userId).set({
        'Name': nameController.text,
        'Email': emailController.text,
        'PhoneNumber': PhoneController.text,
        // Add other fields as needed
      });
         

      // Navigate to the next screen or perform other actions after successful sign-up
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile(userId: '',)),
      );
    } catch (e) {
      // Handle sign-up errors
      print('Sign-up failed: $e');

      // Display a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-up failed: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


  
//google signup
 //google signup
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if the user is signed in and navigate to LocationScreen
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LocationScreen(userId: '',)),
      );
    } else {
      // Handle the case where the user is not signed in
      print('User not signed in after Google Sign-In');
    }

  } catch (e) {
    print(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Google sign-in failed: ${e.toString()}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, statusBarHeight + 20.0, 20.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                'Fill your information below or register',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 0.1),
              const Text(
                'with your social account.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone number',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: PhoneController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0.01),
              Row(
                children: [
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Checkbox(
                        value: agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            agreedToTerms = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                  const Text(
                    'Agree with',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Terms()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Terms and conditions',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.01,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
  onPressed:()  {
   // try {
    //  await _auth.createUserWithEmailAndPassword(
      //  email: emailController.text,
      //  password: passwordController.text,
    //  );
     // Navigator.pushReplacement(
       // context,
      //  MaterialPageRoute(builder: (context) => const LocationScreen()),
     // );
    //} catch (e) {
    //  print(e);
      // Handle errors here, e.g., show an error message
  //  }
 // },
     signUpAndStoreUserData(context);
  },
  child: Text('Sign Up', style: GoogleFonts.inter(color: Colors.white)),
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(15),
    backgroundColor: const Color.fromARGB(255, 1, 101, 252),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
    ),
    minimumSize: const Size(380, 0),
  ),
),

              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    'Or Sign in with',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  InkWell(
                    onTap: () async{
                      
                        await signInWithGoogle(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      child: Image.asset(
                        'images/google.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                   
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signin(userId: '',)),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      ' Sign in.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
