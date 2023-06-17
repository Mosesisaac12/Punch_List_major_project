import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'forgot_password_otp_verify.dart';

class ForgotPassword extends StatefulWidget {
  final String loginAs;
  final String username;
  ForgotPassword({super.key, required this.loginAs, required this.username});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _responseMessage = '';

  final _emailController = TextEditingController();

  void _navigateToOtpVerifyScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ForgotPassOtpVerify(_emailController.text, widget.loginAs);
    }));
  }

  void _sendEmail() async {
    final url = Uri.parse('http://104.236.1.97:5000/request_otp/');
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
          _responseMessage = 'Email verification successful';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_responseMessage),
          backgroundColor: Colors.green,
        ));
        _navigateToOtpVerifyScreen;
      } else {
        setState(() {
          _responseMessage = 'Unsuccessful verfication,Please check Email';
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
      appBar: AppBar(
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          height: 700,
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('Forgot Password',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Please Enter your Registered Email',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  child: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(0, 0, 0, 0.1),
                      filled: true,
                      hintText: 'name@gmail.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onChanged: (value) {
                      // if (value.isEmpty) {

                      //   else if(!value.contains('@')){
                      //     return

                      //   }
                      // }
                    },
                  ),
                ),
                const SizedBox(
                  height: 350,
                ),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: _sendEmail,
                          child: const Text('Continue'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
