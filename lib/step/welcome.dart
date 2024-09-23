import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuck/step/set.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay and then navigate to the main screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE53935), // A deep red color
          image: DecorationImage(
            image:
                AssetImage("assets/image/bac1.png"), // Background pattern image
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Center(
              child: SvgPicture.asset(
                'assets/image/ramen1.svg', // Path to your ramen icon SVG
                height: 80,
                width: 80,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Version 1.0",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for your main screen
