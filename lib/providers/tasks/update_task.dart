import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/widgets.dart';

class UpdateProjectDataProvider with ChangeNotifier {
  Future<Response> updateTask(
    int project,
    String image1,
    String image2,
    String note1,
    String note2,
  ) async {
    final body = json.encode(
      {
        'project': project,
        'images': image1,
        'images': image2,
        'notes': note1,
        'notes': note1,
      },
    );
    print(body);
    final url = Uri.parse('http://104.236.1.97:5000/project/10');
    try {
      final response = await put(
        url,
        headers: {'Authorization': 'token', 'Content-Type': 'application/json'},
        body: body,
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
