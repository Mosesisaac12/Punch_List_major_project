import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class OtpDataProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  Future<Response> verifyUserOtp(
    String username,
    String otp,
  ) async {
    final url = Uri.parse('http://104.236.1.97:5000/verify_user/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': username,
            'otp': otp,
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
