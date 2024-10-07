import 'package:flutter/material.dart';
import 'package:deswift/CreateAccountScreen/verification_medium_screen.dart'; // Import
import 'package:country_code_picker/country_code_picker.dart'; // Import

class ThirdCreateAccountScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String gender;

  const ThirdCreateAccountScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.gender,
  }) : super(key: key);

  @override
  _ThirdCreateAccountScreenState createState() =>
      _ThirdCreateAccountScreenState();
}

class _ThirdCreateAccountScreenState
    extends State<ThirdCreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _phoneNumber;
  String? _countryCode = '+233'; // Default country code for Ghana
  String? _country = 'GHANA'; // Default country name (you'll need to get this)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              // Password
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.remove_red_eye),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              // Phone Number
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    // Country Code Picker
                    CountryCodePicker(
                      onChanged: (countryCode) {
                        setState(() {
                          _countryCode = countryCode.dialCode;
                          _country = countryCode.name?.toUpperCase(); // Get country name
                        });
                      },
                      initialSelection: '+233', // Default to Ghana
                      favorite: ['+233'], // Add Ghana to favorites
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _phoneNumber = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Continue Button (Full Width)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity, // Take full width
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Pass data to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationMediumScreen(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              gender: widget.gender,
                              email: _email!,
                              password: _password!,
                              phoneNumber: _phoneNumber!,
                              countryCode: _countryCode!,
                              country: _country!, // Pass country name
                            ),
                          ),
                        );
                      }
                    },
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
                    child: Text(
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
      ),
    );
  }
}