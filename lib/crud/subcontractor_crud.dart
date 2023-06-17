// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';

// import 'package:punch_list/models/subcontractor_form.dart';

// class SubcontractorService {
//   final String apiUrl = 'http://104.236.1.97:5000/sub_contractor/';

//   Future<List<Subcontractor>> fetchSubcontractors() async {
//     final response =
//         await http.get(Uri.parse(apiUrl), headers: {'Authorization': 'token'});

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final subcontractors = List.from(data).map((item) {
//         return Subcontractor.fromJson(item);
//       }).toList();

//       return subcontractors;
//     } else {
//       throw Exception('Failed to fetch subcontractors');
//     }
//   }

//   Future<http.Response> createSubcontractor(Subcontractor subcontractor) async {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'name': subcontractor.name,
//         'username': subcontractor.email,
//         'mobile_no': subcontractor.phone
//       }),
//     );

//     if (response.statusCode == 201) {
//       return response;
//     } else {
//       throw Exception('Failed to create subcontractor');
//     }
//   }

//   Future<void> updateSubcontractor(Subcontractor subcontractor) async {
//     final url = '$apiUrl/${subcontractor.id}';
//     final response = await http.put(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'name': subcontractor.name,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update subcontractor');
//     }
//   }

//   Future<void> deleteSubcontractor(String id) async {
//     final url = '$apiUrl/$id';
//     final response = await http.delete(Uri.parse(url));

//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete subcontractor');
//     }
//   }
// }
