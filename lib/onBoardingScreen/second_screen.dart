import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';

class SecondScreen extends StatelessWidget {
  final Function onNext;

  SecondScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Animated Gif of Packages
            Center(
              child: SizedBox(
                height: 300, // Set desired height
                width: 300, // Set desired width
                child: Image.asset('assets/images/package.gif'),
              ),
            ),
            SizedBox(height: 30),
            // Animated Text "Track your Delivery live"
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Track your Delivery live',
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
                repeatForever: true,
              ),
            ),
            SizedBox(height: 20),
            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Enjoy speedy delivery that brings your groceries to your door in no time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 40),
            // Horizontal Row for Skip, Dots, and Next
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/create_account');
                    },
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set text color to black
                      ),
                    ),
                    child: Text('Skip'),
                  ),
                  // Page Indicator (Dots)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  // Next Button (Arrow Icon)
                  ElevatedButton(
                    onPressed: () {
                      onNext(); // Call the onNext function
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: CircleBorder(), // Make the button circular
                      padding: EdgeInsets.all(20), // Adjust padding as needed
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.white, // Set icon color to white
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}