import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:punch_list/models/project_model.dart';

class CreateProjectDataProvider with ChangeNotifier {
  Future<Response> sendProjectList(
    String name,
    String address,
    String lotLockSection,
    String zipCode,
    ProjectLocation location,
    String imagePath,
  ) async {
    final url = Uri.parse('http://104.236.1.97:5000/project/');
    try {
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': name,
            'address': address,
            'lot_block_section': lotLockSection,
            'zip_code': zipCode,
            'location': location,
            'images': imagePath,
            // 'images': snapShotPath
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode >= 400) {
        return response;
      }
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
