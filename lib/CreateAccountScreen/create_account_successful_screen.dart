import 'package:flutter/material.dart';
import 'package:deswift/DashboardScreen/dashboard_screen.dart';
import 'package:flutter/services.dart'; //For asset loading


class CreateAccountSuccessfulScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String password;
  final String phoneNumber;
  final String countryCode;
  final String country;
  final String token;
  final bool isVerified;

  const CreateAccountSuccessfulScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
    required this.country,
    required this.token,
    required this.isVerified,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Account Created'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center( // Use Center widget for better alignment
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success image
              Image.asset(
                'assets/images/success.png', // Replace with your image path
                height: 200,
                width: 200,
              ),
              SizedBox(height: 20),
              // Success message
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Congratulations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your account has successfully been created. We can\'t wait for you to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Get Started button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                    'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}