import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class LoginDataProvider with ChangeNotifier {
  String? _token;

  bool isAuth = false;

  Future<Response> login(
      String username, String password, String loginAs) async {
    final url = Uri.parse('http://104.236.1.97:5000/login/');
    try {
      final response = await post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {'username': username, 'password': password, 'login_as': loginAs},
          ));
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        _token = responseBody['token'];
        if (_token != null) {
          isAuth = true;
          print(_token);
          notifyListeners();
          print('notify listener passed');
        }

        return response;
      } else {
        return response;
      }
    } catch (error) {
      rethrow;
    }
  }
}
