import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/widgets.dart';

class SignupDataProvider with ChangeNotifier {
  Future<Response> signup(
      String? username,
      String? fullName,
      int? countryCode,
      String? mobileNo,
      String? password,
      String? confirmPassword,
      String? loginAs) async {
    final url = Uri.parse('http://104.236.1.97:5000/register/');
    try {
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'username': username,
            'fullname': fullName,
            'country_code': countryCode,
            'mobile_no': mobileNo,
            'password': password,
            'confirm_password': confirmPassword,
            'group': loginAs
          },
        ),
      );
      // final responseData = json.decode(response);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body.toString());
        return response;
      } else if (response.statusCode >= 400) {
        print(response.body);
        return response;
      }
      return response;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
