import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:punch_list/models/project_model.dart';
import 'package:punch_list/screens/contractor/projects_screen/create_new_project_screen.dart';
import 'package:punch_list/screens/contractor/projects_screen/project_details_screen.dart';
import 'package:punch_list/screens/contractor/show_subcontractor_screens/subcontractor_list_screen.dart';
import 'package:punch_list/widgets/logout.dart';

class ProjectListScreen extends ConsumerStatefulWidget {
  // String token;
  ProjectListScreen({
    super.key,
    //  required this.token
  });

  @override
  ConsumerState<ProjectListScreen> createState() => ProjectListScreenState();
}

class ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  bool isImageEmpty = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Your Projects'), actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CreateNewProjectScreen();
              }));
            }),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SubContractorScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.man_2_rounded)),
        Logout()
      ]),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('Category of Users')
              .collection('Contractor')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('projects')
              .snapshots(),
          builder: (context, projectsnapShots) {
            if (projectsnapShots.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!projectsnapShots.hasData ||
                projectsnapShots.data!.docs.isEmpty) {
              return Center(child: Text('No projects added yet'));
            }
            if (projectsnapShots.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }

            final loadedProjects = projectsnapShots.data!.docs;
            return ListView.builder(
              itemCount: loadedProjects.length,
              itemBuilder: (context, index) {
                Project project = Project(
                  name: loadedProjects[index].data()['project_name'],
                  address: loadedProjects[index].data()['project_address'],
                  lotBlockSection:
                      loadedProjects[index].data()['project_lot_block_section'],
                  zipCode: loadedProjects[index].data()['project_zip_code'],
                  imageUrl: loadedProjects[index].data()['project_image_url'],
                );
                return Container(
                  margin: EdgeInsets.all(4),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(project.imageUrl!),
                      ),
                      title: Text(
                        project.name!,
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Row(
                        children: [
                          Text(project.address!),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.subdirectory_arrow_right),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ProjectDetailsScreen(project: project);
                          }));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
