import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:punch_list/screens/authorization_screens/login_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassOtpVerify extends StatefulWidget {
  final String username;
  final String loginAs;

  ForgotPassOtpVerify(this.username, this.loginAs, {super.key});

  @override
  State<ForgotPassOtpVerify> createState() => _ForgotPassOtpVerifyState();
}

class _ForgotPassOtpVerifyState extends State<ForgotPassOtpVerify> {
  final Map<String, String> _otpData = {
    'otp': '',
  };
  String _responseMessage = '';
  void _navigateToNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen(
            loginAs: widget.loginAs,
          );
        },
      ),
    );
  }

  void confirmResetUserOtp() async {
    try {
      final url = Uri.parse('http://104.236.1.97:5000/verify_otp/');

      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': widget.username,
            'otp': _otpData['otp'],
          },
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _responseMessage = 'OTP verification successful';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.green,
        ));
        _navigateToNextScreen();
      } else {
        setState(() {
          _responseMessage = 'Unsuccessful verfication,Please check OTP';
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

  Future<void> _resendOtp() async {
    final url = Uri.parse('http://104.236.1.97:5000/resend_otp/');
    try {
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': widget.username,
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
                    'Please type the Otp sent your email:${widget.username} to change your password',
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
                        onPressed: confirmResetUserOtp,
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
