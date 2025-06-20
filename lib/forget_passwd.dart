import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

void main() {
  runApp(const MaterialApp(home: Homepage()));
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isValid = false;

  void _validatePhoneNumber(PhoneNumber phone) {
    final phoneNumberPattern = RegExp(r'^\+?[1-9]\d{1,14}$');
    setState(() {
      _isValid = phoneNumberPattern.hasMatch(phone.completeNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Forgot',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: Image.asset('assets/test5.png')),
          ),
          const SizedBox(height: 1.0),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(50, 2, 30, 1),
              child: Text(
                'Don\'t worry, it happens! Please, enter phone',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(50, 2, 30, 1),
              child: Text(
                'number associated with your account.',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.fromLTRB(1, 40, 130, 5),
            child: const Text(
              'Enter your mobile number',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 2, 35, 2),
            child: IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.check,
                  color: _isValid ? Colors.blue : Colors.grey,
                ),
              ),
              initialCountryCode: 'MA',
              onChanged: _validatePhoneNumber,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: SizedBox(
              width: double.infinity, // Set the width to infinity to take all available space
              height: 47.0,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Send Verification Code',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
