import 'package:deswift/LoginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:deswift/CreateAccountScreen/second_create_account_screen.dart';

class FirstCreateAccountScreen extends StatefulWidget {
  const FirstCreateAccountScreen({Key? key}) : super(key: key);

  @override
  _FirstCreateAccountScreenState createState() =>
      _FirstCreateAccountScreenState();
}

class _FirstCreateAccountScreenState extends State<FirstCreateAccountScreen> {
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: deviceHeight * 0.1),
                Image.asset('assets/images/deswiftlogo.png', height: 150, width: 150),
                SizedBox(height: 15),
                Text(
                  'De-Swift',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _agree
                      ? () {
                    // Handle Google Sign-In
                  }
                      : null, // Enable only if agreed
                  icon: Image.asset('assets/images/googlecircle.png', height: 25, width: 25),
                  label: Text('Continue with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _agree
                      ? () {
                    // Handle Apple Sign-In
                  }
                      : null, // Enable only if agreed
                  icon: Icon(Icons.apple, size: 25, color: Colors.black),
                  label: Text('Continue with Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Or', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _agree
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondCreateAccountScreen()), // Navigate to SecondCreateAccountScreen
                    );
                  }
                      : null,
                  child: Text('Create Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _agree,
                      onChanged: (value) {
                        setState(() {
                          _agree = value!;
                        });
                      },
                      activeColor: Colors.purple, // Set the tick color to purple
                    ),
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.center, // Center the text
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I Agree with ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Terms of Service ',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'and ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.clip, // Ensure text wraps properly
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Do you have an account? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}