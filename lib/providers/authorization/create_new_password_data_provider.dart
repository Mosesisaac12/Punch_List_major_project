import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class CreateNewPasswordDataProvider with ChangeNotifier {
  Future<Response> sendNewPasswordProvider(
      String username, String password, String confirmNewPassword) async {
    final url = Uri.parse('http://104.236.1.97:5000/reset_password/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': username,
            'new_password': password,
            'confirm_new_password': confirmNewPassword
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
