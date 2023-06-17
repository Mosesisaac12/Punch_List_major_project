import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class ResendOtpDataProvider with ChangeNotifier {
  String? _token;

  Future<Response> resendUserOtp(
    String username,
  ) async {
    final url = Uri.parse('http://104.236.1.97:5000/resend_otp/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': username,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (error) {
      rethrow;
    }
  }
}
