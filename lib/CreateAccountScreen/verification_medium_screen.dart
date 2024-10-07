import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'create_account_otp_verification_screen.dart';

class VerificationMediumScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String password;
  final String phoneNumber;
  final String countryCode;
  final String country;

  const VerificationMediumScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
    required this.country,
  }) : super(key: key);

  @override
  _VerificationMediumScreenState createState() =>
      _VerificationMediumScreenState();
}

class _VerificationMediumScreenState extends State<VerificationMediumScreen> {
  String? _selectedMedium;
  bool _isLoading = false;
  String? _token; // To store the token
  bool? _isVerified; // To store is_verified

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://app.de-swift.com/account/customer/register/');
    final body = jsonEncode({
      'authentication_type': _selectedMedium, // Use selected medium
      'email': widget.email,
      'password': widget.password,
      'first_name': widget.firstName,
      'last_name': widget.lastName,
      'gender': widget.gender,
      'country_code': widget.countryCode,
      'country': widget.country,
      'phone_number': widget.phoneNumber,
    });

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      // Registration successful
      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'Registration successful';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      _token = data['token']; // Store the token
      _isVerified = data['is_verified']; // Store is_verified

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountOTPVerificationScreen(
            firstName: widget.firstName,
            lastName: widget.lastName,
            gender: widget.gender,
            email: widget.email,
            password: widget.password,
            phoneNumber: widget.phoneNumber,
            countryCode: widget.countryCode,
            country: widget.country,
            authenticationType: _selectedMedium!,
            token: _token!, // Pass the token
            isVerified: _isVerified!, // Pass is_verified
          ),
        ),
      );
    } else {
      // Handle error (e.g., show a snackbar)
      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'An error occurred';
      final error = data['error'] ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$message\n$error'),
        ),
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
        title: Text('Choose Verification Medium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select which contact details should we your verification code.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Verification Method Selection
            _buildVerificationMethodCard(
              icon: Icons.email_outlined,
              title: 'Send via Email',
              details: widget.email,
              isSelected: _selectedMedium == 'email',
              onTap: () {
                setState(() {
                  _selectedMedium = 'email';
                });
              },
            ),
            SizedBox(height: 15),
            _buildVerificationMethodCard(
              icon: Icons.message_outlined,
              title: 'Send via SMS',
              details: widget.countryCode + widget.phoneNumber,
              isSelected: _selectedMedium == 'sms',
              onTap: () {
                setState(() {
                  _selectedMedium = 'sms';
                });
              },
            ),
            SizedBox(height: 30),
            // Continue Button (Full Width)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity, // Take full width
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,
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
                    color: Colors.white,
                  )
                      : Text(
                    'Continue',
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

  Widget _buildVerificationMethodCard({
    required IconData icon,
    required String title,
    required String details,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: isSelected ? Colors.purple : Colors.grey,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      details,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 25,
                  color: Colors.purple,
                ),
            ],
          ),
        ),
      ),
    );
  }
}