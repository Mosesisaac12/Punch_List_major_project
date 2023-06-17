import 'dart:io';

import 'package:flutter/material.dart';
import 'package:punch_list/models/subcontractor_form.dart';
import 'package:punch_list/providers/sub_contractor/add_subcontractor.dart';
import '../../../models/task_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:punch_list/providers/tasks/create_task.dart';

class ShowTasksScreen extends ConsumerStatefulWidget {
  const ShowTasksScreen({super.key});

  @override
  _ShowTasksScreenState createState() => _ShowTasksScreenState();
}

class _ShowTasksScreenState extends ConsumerState<ShowTasksScreen> {
  final _taskFormKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();
  final taskDescController = TextEditingController();
  File? _takenImage;

  Subcontractor selectedSubcontractor = Subcontractor(
    name: 'Moses',
    email: 'moses@gmail.com',
    phone: '7355250546',
  );

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

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _takenImage = File(pickedImage.path);
    });
  }

  Future<void> _uploadPicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _takenImage = File(pickedImage.path);
    });
  }

  void _showTaskForm() {
    final subcontractor = ref.watch(subcontractorProvider);
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
                      TextButton.icon(
                        icon: const Icon(Icons.camera),
                        label: const Text('Take Picture'),
                        onPressed: _takePicture,
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.photo),
                        label: const Text('Upload Picture'),
                        onPressed: _uploadPicture,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<Subcontractor>(
                    value: selectedSubcontractor,
                    onChanged: (Subcontractor? newValue) {
                      setState(() {
                        selectedSubcontractor = newValue!;
                      });
                    },
                    items: subcontractor.map<DropdownMenuItem<Subcontractor>>(
                        (Subcontractor subcontractor) {
                      return DropdownMenuItem(
                        value: subcontractor,
                        child: Text(subcontractor.name!),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Subcontractor',
                    ),
                  ),
                  ElevatedButton(onPressed: _savetask, child: Text('Submit'))
                ]),
              ));
        });
  }

  void _savetask() {
    final isValid = _taskFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _taskFormKey.currentState?.save();
    final task = Task(
        name: taskNameController.text,
        subcontractor: selectedSubcontractor.name!,
        description: taskDescController.text,
        image: _takenImage);
    ref.read(taskProvider.notifier).addtask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final tasks = ref.watch(taskProvider);

    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punch List'),
      ),
      body: Column(
        children: [
          Container(
            height: 600,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final hasSubcontractor = task.subcontractor.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListTile(
                    leading: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(task.image!)),
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(task.description),
                        const SizedBox(height: 8.0),
                        // Text(
                        //   // 'Assigned: ${task.timeAssigned.toString()}',
                        //  , style: TextStyle(color: Colors.grey),
                        // ),
                        const SizedBox(height: 8.0),
                        if (hasSubcontractor)
                          Text('Subcontractor: ${task.subcontractor}')
                        else
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
                      _showTaskDescription(context, task.description);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
              height: 50,
              width: 200,
              decoration: const BoxDecoration(),
              child: ElevatedButton(
                onPressed: _showTaskForm,
                style: ElevatedButton.styleFrom(),
                child: const Text('Add Task'),
              ))
        ],
      ),
    );
    // ElevatedButton(onPressed: () {}, child: Text('Add Task'))),
  }
}
