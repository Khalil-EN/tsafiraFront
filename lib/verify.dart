import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar_example/HomePage.dart';
import 'services/api.dart';

void main() {
  runApp(const MaterialApp(home: Verify()));
}

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _HomepageState();
}

class _HomepageState extends State<Verify> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  int _countdown = 60;
  late Timer _timer;
  bool _canResend = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _setupFieldListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _setupFieldListeners() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
        _validateFields();
      });
    }
  }

  void _validateFields() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);
    setState(() => _isVerified = allFilled);
  }

  void _resendCode() {
    setState(() {
      _countdown = 60;
      _canResend = false;
      _controllers.forEach((c) => c.clear());
      _isVerified = false;
    });
    _startTimer();
    _focusNodes[0].requestFocus();
    // Add your resend code API call here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text(
          'Verify',
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
            child: Center(child: Image.asset('assets/test4.png')),
          ),
          const SizedBox(height: 1.0),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Enter Verification Code',
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
              margin: const EdgeInsets.fromLTRB(20, 2, 20, 1),
              child: Text(
                'A 4 digit number has been sent to ',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                '+212712345678',
                style: TextStyle(
                    fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: SizedBox(
              width: double.infinity,
              height: 47.0,
              child: ElevatedButton(
                onPressed: _isVerified
                    ? () {
                  Api.helloWorld();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }
                    : null,
                child: const Text('Verify',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: _canResend ? _resendCode : null,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 2, 20, 1),
                child: Text(
                  _canResend
                      ? 'Resend Code'
                      : 'Resend Code (${_countdown.toString().padLeft(2, '0')})',
                  style: TextStyle(
                    fontSize: 15,
                    color: _canResend ? Colors.blue : Colors.grey[600],
                    decoration: _canResend ? TextDecoration.underline : null,
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