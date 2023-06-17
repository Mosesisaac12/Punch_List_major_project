import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:punch_list/providers/project/create_new_project_provide.dart';
import 'package:punch_list/screens/contractor/projects_screen/project_details_screen.dart';
import '../../../models/project_model.dart';
import 'create_new_project_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectListScreen extends ConsumerStatefulWidget {
  String token;
  ProjectListScreen({super.key, required this.token});

  @override
  ConsumerState<ProjectListScreen> createState() => ProjectListScreenState();
}

class ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  bool isImageEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  final String apiUrl = 'http://104.236.1.97:5000/project/';
  Future<List<Project>> fetchProjects() async {
    final response =
        await get(Uri.parse(apiUrl), headers: {'Authorization': widget.token});

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

  Future<void> updateProject() async {
    final response = await patch(Uri.parse(apiUrl),
        headers: {'Authorization': widget.token});

    if (response.statusCode == 200) {
      setState(() {
        fetchProjects();
      });
      final data = json.decode(response.body);
    } else {
      throw Exception('Failed to update project');
    }
  }

  Future<void> deleteProject() async {
    final response = await delete(Uri.parse(apiUrl),
        headers: {'Authorization': widget.token});

    if (response.statusCode == 200) {
      setState(() {
        fetchProjects();
      });
      final data = json.decode(response.body);
    } else {
      throw Exception('Failed to delete project');
    }
  }

  @override
  Widget build(BuildContext context) {
    final newProjects = ref.watch(newProjectProvider);

    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punch List Projects'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 207, 232, 255),
        ),
        child: Column(
          children: [
            newProjects.isEmpty
                ? Container(
                    height: 600,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('No Projects added yet'),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 600,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: newProjects.length,
                          itemBuilder: (context, index) {
                            Project project = newProjects[index];
                            return Card(
                              shape: StadiumBorder(),
                              elevation: 8,
                              child: Container(
                                height: 80,
                                width: double.infinity,
                                padding: EdgeInsets.all(6),
                                margin: EdgeInsets.all(6),
                                child: ListTile(
                                  leading: project.image == null
                                      ? const Text('no image uploaded')
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              FileImage(project.image!),
                                        ),

                                  title: Text(
                                    project.name!,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(project.address!),
                                      Text(' || '),
                                      Text(project.lotBlockSection!),
                                      Text(' || '),
                                      Text(project.zipCode!),
                                    ],
                                  ),
                                  trailing:
                                      Icon(Icons.arrow_circle_right_sharp),
                                  // subtitle: Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text(project.address!),
                                  //     Text('Lot BLock Section: ${project.lotBlockSection}'),
                                  //     Text('Zip Code: ${project.zipCode}'),
                                  //   ],
                                  // ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (ctx) {
                                      return ProjectDetailsScreen(
                                          project: project);
                                    }));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CreateNewProjectScreen(
                          // token: widget.token,
                          );
                    }));
                    setState(() {
                      fetchProjects();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text('Create New Project')),
            )
          ],
        ),
      ),
    );
  }
}
