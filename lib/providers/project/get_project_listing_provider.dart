import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/widgets.dart';

class FetchProjectListingDataProvider with ChangeNotifier {
  Future<Response> fetchProjectsLists(
    int? page,
  ) async {
    final url = Uri.parse('http://104.236.1.97:5000/project/?page=page/');
    try {
      final response = await get(
        url,
        headers: {'Authorization': 'token', 'Content-Type': 'application/json'},
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
