 // verification_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  String enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
        
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'Verify Code',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 25.0,
                ),
              ),
            
                Text(
                  'Please enter the code we just sent to your email',
                   style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
                  
                ),
              
            Text(
              '${widget.email}',
              style: TextStyle(fontSize: 12),
            ),
          
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  enteredOtp = value;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate the entered OTP and proceed accordingly
                // For simplicity, let's assume the correct OTP is '123456'
                if (enteredOtp == '123456') {
                  // Navigate to the success page or perform further actions
                  // For now, just print a message
                  print('OTP verification successful!');
                } else {
                  // Handle incorrect OTP
                  print('Incorrect OTP. Please try again.');
                }
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
