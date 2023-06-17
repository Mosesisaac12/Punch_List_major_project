import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/widgets.dart';

class UpdateProjectDataProvider with ChangeNotifier {
  Future<Response> updateProject(
    String name,
    String address,
    String lotLockSection,
    String zipCode,
    double lat,
    double lon,
    int removeImagesId1,
    int removeImagesId2,
    String imagePath,
    String snapShotPath,
  ) async {
    final body = json.encode(
      {
        'name': name,
        'address': address,
        'lot_block_section': lotLockSection,
        'zip_code': zipCode,
        'lat': lat,
        'lon': lon,
        'remove_images_id': removeImagesId1,
        'remove_images_id': removeImagesId2,
        'images': imagePath,
        'images': snapShotPath,
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
