import 'package:flutter/material.dart';

import 'package:punch_list/screens/authorization_screens/login_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'dart:convert';

import 'package:http/http.dart';

class EmailOtp extends StatefulWidget {
  final String _username;
  final String group;
  const EmailOtp(this._username, this.group, {super.key});

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  final Map<String, String> _otpData = {
    'otp': '',
  };
  String _responseMessage = '';
  void _navigateToNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoginScreen(
            loginAs: widget.group,
          );
        },
      ),
    );
  }

  void _saveOtp() async {
    try {
      final url = Uri.parse('http://104.236.1.97:5000/verify_user/');

      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': widget._username,
            'otp': _otpData['otp'],
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _responseMessage = responseData['message'];
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.green,
        ));
        _navigateToNextScreen();
      } else {
        setState(() {
          _responseMessage = responseData['message'];
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    final url = Uri.parse('http://104.236.1.97:5000/resend_otp/');
    try {
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': widget._username,
          },
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _responseMessage = 'OTP sent successfully, please check your e-mail';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.green,
        ));
      } else {
        setState(() {
          _responseMessage = 'Unable to send OTP,please try again';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      setState(() {
        _responseMessage = 'Something went wrong,please try again';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_responseMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(foregroundColor: Colors.white),
        body: SafeArea(
          child: Container(
            height: 800,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OTP Verification',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    'Please type the Otp sent your email:${widget._username} to complete the Signup',
                  ),
                  PinCodeTextField(
                    appContext: context,
                    //  controller: _otpController,
                    length: 6,
                    // obscureText: true,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.blue,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black,
                      selectedColor: Colors.black,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {
                      _otpData['otp'] = value;
                      print(_otpData['otp']);
                    },
                    onCompleted: (value) {
                      // Handle OTP verification here
                    },
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Otp not received?'),
                    TextButton(
                        onPressed: _resendOtp, child: const Text('RESEND')),
                  ]),
                  Center(
                    child: ElevatedButton(
                        onPressed: _saveOtp,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Submit Button')),
                  )
                ]),
          ),
        ));
  }
}
