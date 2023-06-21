import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:punch_list/models/project_model.dart';
import 'package:punch_list/models/subcontractor_form.dart';

import 'package:image_picker/image_picker.dart';

import 'package:punch_list/models/task_model.dart';
import 'package:punch_list/widgets/image_upload.dart';

class ShowTasksScreen extends StatefulWidget {
  final Project project;
  ShowTasksScreen({super.key, required this.project});

  @override
  _ShowTasksScreenState createState() => _ShowTasksScreenState();
}

class _ShowTasksScreenState extends State<ShowTasksScreen> {
  final _taskFormKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();
  final taskDescController = TextEditingController();
  File? _selectedImage;

  Subcontractor selectedSubcontractor = Subcontractor(
    name: 'Moses',
    email: 'moses@gmail.com',
    phone: '7355250546',
  );

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescController.dispose();
    super.dispose();
  }

  void _showTaskDescription(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task Description'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _takePicture() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage = await imagePicker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 600,
  //   );

  //   if (pickedImage == null) {
  //     return;
  //   }

  //   setState(() {
  //     _takenImage = File(pickedImage.path);
  //   });
  // }

  // Future<void> _uploadPicture() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage = await imagePicker.pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 600,
  //   );

  //   if (pickedImage == null) {
  //     return;
  //   }

  //   setState(() {
  //     _takenImage = File(pickedImage.path);
  //   });
  // }

  void _showTaskForm() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _taskFormKey,
                child: Column(children: <Widget>[
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                    ),
                    controller: taskNameController,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                    ),
                    controller: taskDescController,
                  ),
                  const SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     labelText: 'Upload Task Image',
                  //   ),
                  // ),
                  Column(
                    children: [
                      // TextButton.icon(
                      //   icon: const Icon(Icons.camera),
                      //   label: const Text('Take Picture'),
                      //   onPressed: _takePicture,
                      // ),
                      // TextButton.icon(
                      //   icon: const Icon(Icons.photo),
                      //   label: const Text('Upload Picture'),
                      //   onPressed: _uploadPicture,
                      // ),
                      ImageUpload(onTakenImage: (takenImage) {
                        _selectedImage = takenImage;
                      })
                    ],
                  ),
                  SizedBox(height: 16.0),
                  // DropdownButtonFormField<Subcontractor>(
                  //   value: selectedSubcontractor,
                  //   onChanged: (Subcontractor? newValue) {
                  //     setState(() {
                  //       selectedSubcontractor = newValue!;
                  //     });
                  //   },
                  //   items: subcontractor.map<DropdownMenuItem<Subcontractor>>(
                  //       (Subcontractor subcontractor) {
                  //     return DropdownMenuItem(
                  //       value: subcontractor,
                  //       child: Text(subcontractor.name!),
                  //     );
                  //   }).toList(),
                  //   decoration: InputDecoration(
                  //     labelText: 'Select Subcontractor',
                  //   ),
                  // ),
                  ElevatedButton(onPressed: _savetask, child: Text('Submit'))
                ]),
              ));
        });
  }

  void _savetask() async {
    final isValid = _taskFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _taskFormKey.currentState?.save();
    final task = Tasks(
        name: taskNameController.text,
        subcontractor: selectedSubcontractor.name!,
        description: taskDescController.text,
        image: _selectedImage);

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.project.name)
        .get();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('task_image')
        .child('${widget.project.name!}-${task.name}.jpg');

    await storageRef.putFile(task.image!);
    final imageURL = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc('${widget.project.name}-${task.name}')
        .set({
      'task_name': task.name,
      'task_subcontractor': task.subcontractor,
      'task_description': task.description,
      'image_url': imageURL
    });
    // ref.read(taskProvider.notifier).addtask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punch List'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, tasksnapShots) {
            if (tasksnapShots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!tasksnapShots.hasData || tasksnapShots.data!.docs.isEmpty) {
              return Center(child: Text('No tasks added yet'));
            }

            if (tasksnapShots.hasError) {
              Center(child: Text('Something went wrong'));
            }

            final loadedTasks = tasksnapShots.data!.docs;
            return ListView.builder(
              itemCount: loadedTasks.length,
              itemBuilder: (context, index) {
                Tasks projectTask = Tasks(
                    name: loadedTasks[index].data()['task_name'],
                    description: loadedTasks[index].data()['task_description'],
                    ImageURL: loadedTasks[index].data()['image_url']);
                // final task = loadedTasks[index];
                // final hasSubcontractor = task.subcontractor.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListTile(
                    leading: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(projectTask.ImageURL!),
                        ),
                      ),
                    ),
                    title: Text(projectTask.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(projectTask.description),
                        const SizedBox(height: 8.0),
                        // Text(
                        //   // 'Assigned: ${task.timeAssigned.toString()}',
                        //  , style: TextStyle(color: Colors.grey),
                        // ),
                        const SizedBox(height: 8.0),
                        // if (hasSubcontractor)
                        //   Text('Subcontractor: ${task.subcontractor}')
                        // else
                        const Column(
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 16.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'No subcontractor assigned',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      _showTaskDescription(context, projectTask.description);
                    },
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: _showTaskForm, child: Icon(Icons.add_sharp)),
    );
  }
}
