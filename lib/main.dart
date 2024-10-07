import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreateAccountScreen/first_create_account_screen.dart';
import 'DashboardScreen/dashboard_screen.dart';
import 'onBoardingScreen/first_screen.dart';
import 'onBoardingScreen/second_screen.dart';
import 'onBoardingScreen/third_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TokenVerificationScreen(), // Check token on app start
      routes: {
        '/create_account': (context) => FirstCreateAccountScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}

class TokenVerificationScreen extends StatefulWidget {
  @override
  _TokenVerificationScreenState createState() => _TokenVerificationScreenState();
}

class _TokenVerificationScreenState extends State<TokenVerificationScreen> {
  bool _isLoading = true; // To show loading while checking token

  @override
  void initState() {
    super.initState();
    _checkToken(); // Check token when screen loads
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Fetch token from prefs

    if (token != null) {
      // If token exists, verify it
      final url = Uri.parse('http://app.de-swift.com/account/customer/authenticated/');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Add token to the request
      });

      if (response.statusCode == 200) {
        // Token is valid, navigate to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Token invalid or not provided, show onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        );
      }
    } else {
      // No token found, show onboarding screens
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading while checking token
          : Container(), // Will not show this screen since navigation will happen
    );
  }
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentScreenIndex,
        children: [
          FirstScreen(
            onNext: () {
              setState(() {
                _currentScreenIndex = 1;
              });
            },
          ),
          SecondScreen(
            onNext: () {
              setState(() {
                _currentScreenIndex = 2;
              });
            },
          ),
          ThirdScreen(
            onSkip: () {
              Navigator.pushReplacementNamed(context, '/create_account');
            },
          ),
        ],
      ),
    );
  }
}
