import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Get.offNamed('/'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF06292), 
        child: Center(
          child: Text(
            'Notion app',
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              fontStyle: FontStyle.italic, 
              color: Colors.white, 
            ),
          ),
        ),
      ),
    );
  }
}