import 'package:deswift/ResetPasswordScreen/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'create_new_password_screen.dart';

class ResetPasswordOTPVerificationScreen extends StatefulWidget {
  final String email;

  const ResetPasswordOTPVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  _ResetPasswordOTPVerificationScreenState createState() =>
      _ResetPasswordOTPVerificationScreenState();
}

class _ResetPasswordOTPVerificationScreenState
    extends State<ResetPasswordOTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _otp = '';
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
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP Expired. Please regenerate.'),
            ),
          );
        }
      });
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
    final body = jsonEncode({
      'authentication_type': 'email',
      'email': widget.email,
      'otp': _otp!,
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // OTP verification successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewPasswordScreen(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect OTP. Please try again.')),
      );
    }
  }

  Future<void> _regenerateOTP() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'http://app.de-swift.com/account/customer/otp/regenerate/');
    final body = jsonEncode({
      'authentication_type': 'email',
      'email': widget.email,
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

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
            // Email Display (You can customize this)
            Text(
              widget.email,
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
    return Container(
      width: 100,
      height: 100,
      child: TextField(
        autofocus: true,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            if (index == 0) {
              _otp = value;
            } else if (index == 1) {
              _otp = _otp! + value;
            } else if (index == 2) {
              _otp = _otp! + value;
            } else if (index == 3) {
              _otp = _otp! + value;
            }
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: InputDecoration(
          counterText: '',
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