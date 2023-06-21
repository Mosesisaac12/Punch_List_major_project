import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:punch_list/crud/projects_crud.dart';
import 'package:punch_list/providers/project/create_new_project_provide.dart';
import 'package:punch_list/screens/contractor/projects_screen/projects_lists_screen.dart';
import 'package:punch_list/screens/contractor/show_subcontractor_screens/subcontractor_list_screen.dart';
import 'package:punch_list/widgets/image_upload.dart';
import '../../../models/project_model.dart';
import '../../../speech_to_text.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import '../../../widgets/location.dart';

class CreateNewProjectScreen extends ConsumerStatefulWidget {
  // String token;
  CreateNewProjectScreen({
    super.key, //required this.token
  });

  @override
  ConsumerState<CreateNewProjectScreen> createState() =>
      CreateNewProjectScreenState();
}

class CreateNewProjectScreenState
    extends ConsumerState<CreateNewProjectScreen> {
  final _projectFormKey = GlobalKey<FormState>();
  // final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  File? _selectedImage;
  bool isListening = false;
  ProjectLocation? _selectedLocation;
  final ProjectsService projectsService = ProjectsService();
  bool isLoading = false;
  // @override
  // void initState() {
  //   super.initState();
  //   _initSpeech();
  // }

  /// This has to happen only once per app
  // void _initSpeech() async {
  //   _speechEnabled = await _speechToText.initialize();
  //   setState(() {});
  // }

  // /// Each time to start a speech recognition session
  // void _startListening() async {
  //   await _speechToText.listen(onResult: _onSpeechResult);

  //   // myTextFieldController.text = _onSpeechResult(result);
  //   setState(() {});
  // }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  // void _stopListening() async {
  //   await _speechToText.stop();
  //   setState(() {});
  // }

  // /// This is the callback that the SpeechToText plugin calls when
  // /// the platform returns recognized words.
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _lastWords = result.recognizedWords;
  //   });
  // }

  // projects.add(
  //  name =_projectData['name'];
  //  address =_projectData['name'];
  //  lotLockSection =_projectData['name'];
  // zipCode =_projectData['name'];
  //  imagePath  =_projectData['name'];
  //  latitude  =_projectData['name'];
  // longitude =_projectData['name'];

  //    ));

  final Map<String, dynamic> _projectData = {
    'name': '',
    'address': '',
    'lotBlockSection': '',
    'zipCode': '',
    'latitude': '',
    'longitude': ''
  };

  // final String apiUrl = 'http://104.236.1.97:5000/project/';
  // Future<List<Project>> fetchProjects() async {
  //   final response =
  //       await get(Uri.parse(apiUrl), headers: {'Authorization': widget.token});

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final projects = List.from(data).map((item) {
  //       return Project.fromJson(item);
  //     }).toList();

  //     return projects;
  //   } else {
  //     throw Exception('Failed to fetch subcontractors');
  //   }
  // }

  void _saveProject() async {
    try {
      final isValid = _projectFormKey.currentState?.validate();
      if (!isValid!) {
        return;
      }
      _projectFormKey.currentState?.save();
      final project = Project(
          name: _projectData['name'],
          address: _projectData['address'],
          lotBlockSection: _projectData['lotBlockSection'],
          zipCode: _projectData['zipCode'],
          image: _selectedImage,
          location: _selectedLocation);
      setState(() {
        isLoading = true;
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('project_images')
          .child('${project.name}-${DateTime.now()}.jpg');

      await storageRef.putFile(project.image!);
      final imageUrl = await storageRef.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser!;

      await FirebaseFirestore.instance
          .collection('projects')
          .doc(project.name)
          .set({
        'project_name': project.name,
        'project_address': project.address,
        'project_lot_block_section': project.lotBlockSection,
        'project_zip_code': project.zipCode,
        'project_image_url': imageUrl,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
      });
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      Exception(error);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
      return ProjectListScreen();
    })));
  }

  final _addressFocusNode = FocusNode();
  final _lotBlockSectionFocusNode = FocusNode();
  final _zipCodeFocusNode = FocusNode();

  @override
  void dispose() {
    _addressFocusNode.dispose();
    _lotBlockSectionFocusNode.dispose();
    _zipCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt_rounded),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProjectListScreen();
              }));
            },
          ),
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
              icon: Icon(Icons.carpenter)),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: maxHeight * 1.0,
                  margin: EdgeInsets.symmetric(
                      vertical: maxHeight * 0.01, horizontal: maxWidth * 0.02),
                  padding: EdgeInsets.symmetric(
                      vertical: maxHeight * 0.01, horizontal: maxWidth * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColor,
                            Colors.white
                          ])),
                  child: Form(
                    key: _projectFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Create Project',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: maxHeight * 0.01,
                                  horizontal: maxWidth * 0.03),
                              child: Text('Project Name'),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocusNode);
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Project Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              onChanged: (value) {
                                _projectData['name'] = value;
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: maxHeight * 0.01,
                                  horizontal: maxWidth * 0.03),
                              child: Text('Address'),
                            ),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                focusNode: _addressFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_lotBlockSectionFocusNode);
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Address',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none),
                                  ),
                                ),
                                onChanged: (value) {
                                  _projectData['address'] = value;
                                }),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: maxHeight * 0.01,
                                  horizontal: maxWidth * 0.03),
                              child: Text('Lot Block Section'),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _lotBlockSectionFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_zipCodeFocusNode);
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Lot Block Section',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                              ),
                              onChanged: (value) {
                                _projectData['lotBlockSection'] = value;
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: maxHeight * 0.01,
                                  horizontal: maxWidth * 0.03),
                              child: Text('Zip Code'),
                            ),
                            TextFormField(
                                focusNode: _zipCodeFocusNode,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Zip Code',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none),
                                  ),
                                ),
                                onChanged: (value) {
                                  _projectData['zipCode'] = value;
                                }),
                          ],
                        ),
                        ImageUpload(
                          onTakenImage: (takenImage) {
                            _selectedImage = takenImage;
                          },
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: maxHeight * 0.01,
                                  horizontal: maxWidth * 0.03),
                              child: Text('PIN LOCATION'),
                            ),
                          ],
                        ),
                        // Center(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text('Current Location:'),
                        //       Text(
                        //         _currentLocation,
                        //         style: TextStyle(
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       Container(
                        //         height: 30,
                        //         width: 40,
                        //         decoration: BoxDecoration(border: Border.all()),
                        //         child: previewContent,
                        //       ),
                        //       const SizedBox(height: 20),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           IconButton(
                        //             icon: const Icon(Icons.location_on),
                        //             onPressed: _getCurrentLocation,
                        //           ),
                        //           IconButton(
                        //             icon: const Icon(Icons.map),
                        //             onPressed: _selectLocationOnMap,
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //     height: 20,
                        //     width: 300,
                        //     child: LocationScreen(
                        //       onSelectLocation: (location) {
                        //         _selectedLocation = location;
                        //       },
                        //     )),
                        Center(
                          child: SizedBox(
                            height: maxHeight * 0.07,
                            width: maxWidth * 0.8,
                            // height: 20,
                            // width: 200,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    foregroundColor: Colors.white),
                                onPressed: _saveProject,
                                // showDialog(
                                //     context: context,
                                //     builder: (ctx) {
                                //       return AlertDialog(
                                //         title: Text('Create Punch List'),
                                //         content: Text(
                                //             'Do you want to create a Punch list for this project?'),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: _showDialogCreateTask,
                                //             child: Text('Yes'),
                                //           ),
                                //           TextButton(
                                //               onPressed: _showDialogLater,
                                //               child: Text('Later'))
                                //         ],
                                //       );
                                //     });

                                child: const Text('Submit')),
                          ),
                        ),
                        // Center(
                        //   child: ElevatedButton(
                        //       onPressed: () {
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: (_) {
                        //               return;
                        //               // const SpeechSampleApp();
                        //             },
                        //           ),
                        //         );
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         foregroundColor: Colors.white,
                        //         shape: const StadiumBorder(),
                        //       ),
                        //       child: const Text('Speech')),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
