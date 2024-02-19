 import 'package:flutter/material.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('wait'),
      ),
      body: Center(
        child: Text(
          'Your request is pending',
          style: TextStyle(fontSize: 20),
        ),
      ),
      
    );
  }
}