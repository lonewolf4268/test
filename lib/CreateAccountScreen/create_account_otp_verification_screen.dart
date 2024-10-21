import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:deswift/CreateAccountScreen/create_account_successful_screen.dart';

class CreateAccountOTPVerificationScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String password;
  final String phoneNumber;
  final String countryCode;
  final String country;
  final String authenticationType;
  final String token; // Receive token from previous screen
  final bool isVerified; // Receive isVerified from previous screen

  const CreateAccountOTPVerificationScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
    required this.country,
    required this.authenticationType,
    required this.token,
    required this.isVerified,
  }) : super(key: key);

  @override
  _CreateAccountOTPVerificationScreenState createState() =>
      _CreateAccountOTPVerificationScreenState();
}

class _CreateAccountOTPVerificationScreenState
    extends State<CreateAccountOTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _otp = ''; // Initialize OTP
  bool _isLoading = false;
  int _secondsRemaining = 300; // 5 minutes countdown
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP Expired. Please regenerate.'),
          ),
        );
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOTP() async {
    if (_otp == null || _otp!.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 4-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://app.de-swift.com/account/customer/otp/verify/');
    var body;

    if (widget.authenticationType == 'email') {
      body = jsonEncode({
        'authentication_type': widget.authenticationType,
        'email': widget.email,
        'otp': _otp!,
      });
    } else if (widget.authenticationType == 'sms') {
      body = jsonEncode({
        'authentication_type': widget.authenticationType,
        'country_code': widget.countryCode,
        'country': widget.country,
        'phone_number': widget.phoneNumber,
        'otp': _otp!,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid authentication medium.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      _saveUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect OTP. Please try again.')),
      );
    }
  }

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', widget.token);
    await prefs.setBool('is_verified', widget.isVerified);
    await prefs.setString('first_name', widget.firstName);
    await prefs.setString('last_name', widget.lastName);
    await prefs.setString('country', widget.country);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountSuccessfulScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          gender: widget.gender,
          email: widget.email,
          password: widget.password,
          phoneNumber: widget.phoneNumber,
          countryCode: widget.countryCode,
          country: widget.country,
          token: widget.token,
          isVerified: widget.isVerified,
        ),
      ),
    );
  }

  Future<void> _regenerateOTP() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://app.de-swift.com/account/customer/otp/regenerate/');
    var body;

    if (widget.authenticationType == 'email') {
      body = jsonEncode({
        'authentication_type': widget.authenticationType,
        'email': widget.email,
      });
    } else if (widget.authenticationType == 'sms') {
      body = jsonEncode({
        'authentication_type': widget.authenticationType,
        'country_code': widget.countryCode,
        'country': widget.country,
        'phone_number': widget.phoneNumber,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid authentication medium.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'OTP sent successfully';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } else {
      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'An error occurred';
      final error = data['error'] ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$message\n$error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the verification code we sent you:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '${widget.countryCode} ${widget.phoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // OTP Input
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOTPInput(0),
                SizedBox(width: 10),
                _buildOTPInput(1),
                SizedBox(width: 10),
                _buildOTPInput(2),
                SizedBox(width: 10),
                _buildOTPInput(3),
              ],
            ),
            SizedBox(height: 20),
            // Didn't receive OTP
            TextButton(
              onPressed: _isLoading ? null : _regenerateOTP,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Didn\'t receive code? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Timer display
            Text(
              'Time remaining: ${_formatTime(_secondsRemaining)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            // Verify Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                      'Verify',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method for creating OTP input fields
  Widget _buildOTPInput(int index) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the width of each OTP input box based on screen width and number of boxes
    // Assuming 4 boxes, subtract some padding or spacing
    final boxWidth = (screenWidth - 40) / 4; // Adjust padding as needed

    return Container(
      width: boxWidth, // Use dynamic width
      height: boxWidth, // Set height same as width for a square box
      child: TextFormField(
        autofocus: true,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            if (index == 0) {
              _otp = value;
            } else {
              _otp = _otp! + value;
            }
            FocusScope.of(context).nextFocus(); // Move to the next input
          } else {
            FocusScope.of(context).previousFocus(); // Move to the previous input
          }
        },
        decoration: InputDecoration(
          counterText: '', // Hide character counter
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
