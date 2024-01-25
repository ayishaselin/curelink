 import 'package:flutter/material.dart';
import 'package:flutter_application_1/profilecomp.dart';
import 'package:google_fonts/google_fonts.dart';


class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (index) => TextEditingController());
    otpFocusNodes = List.generate(4, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
            const SizedBox(height: 20),

              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 60.0,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      counterText: '',  
                    ),
                    onChanged: (value) {
                      // Move focus to the next TextField when a digit is entered
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                      }
                    },
                    focusNode: otpFocusNodes[index],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 40),
            Text(
              'Didn’t receive OTP?',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle "Resend code" button press
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Resend code',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.blue,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile()));
                // Handle verification logic here
                // You can access the entered OTP using otpControllers[index].text
              },
              child: Text('Verify', style: GoogleFonts.inter(color: Colors.white)),
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
          ],
        ),
      ),
    );
  }
}
