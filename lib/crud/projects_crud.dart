import 'dart:convert';

import 'package:http/http.dart';
import 'package:punch_list/models/project_model.dart';

class ProjectsService {
  final String apiUrl = 'http://104.236.1.97:5000/sub_contractor/';

  Future<List<Project>> fetchProjects() async {
    final response =
        await get(Uri.parse(apiUrl), headers: {'Authorization': 'token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final projects = List.from(data).map((item) {
        return Project.fromJson(item);
      }).toList();

      return projects;
    } else {
      throw Exception('Failed to fetch subcontractors');
    }
  }

  void _createProject() {}
  void updateProject() {}
  void deleteProject() {}
}
