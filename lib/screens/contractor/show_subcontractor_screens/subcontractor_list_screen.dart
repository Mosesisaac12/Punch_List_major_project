import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:punch_list/widgets/image_upload.dart';
import '../../../models/subcontractor_form.dart';

class SubContractorScreen extends ConsumerStatefulWidget {
  SubContractorScreen({super.key});

  @override
  ConsumerState<SubContractorScreen> createState() =>
      _SubContractorScreenState();
}

class _SubContractorScreenState extends ConsumerState<SubContractorScreen> {
  GlobalKey<FormState> subcontractorFormKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController profileImage = TextEditingController();

  File? selectedImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  void _saveSubcontractor() async {
    final isValid = subcontractorFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      subcontractorFormKey.currentState?.save();
      final subcontractors = Subcontractor(
        name: name.text,
        email: email.text,
        phone: phone.text,
        image: selectedImage,
      );

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('subcontractor_images')
          .child('${subcontractors.name}-${subcontractors.email}');

      await storageRef.putFile(subcontractors.image!);
      final imageURL = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Subcontractors List')
          .doc('${subcontractors.email}')
          .set({
        'subcontractor_name': subcontractors.name,
        'subcontractor_email': subcontractors.email,
        'subcontractor_phone': subcontractors.phone,
        'subcontractor_image_url': imageURL
      });
      Navigator.of(context).pop();
    }
  }

  void _showAddSubcontractorModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: subcontractorFormKey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Add New Subcontractor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ImageUpload(onTakenImage: (takenImage) {
                selectedImage = takenImage;
              }),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSubcontractor,
                  child: const Text('ADD'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcontractors'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Subcontractors List')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Subcontractors added yet'));
          }

          final loadedSubcontractorsList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: loadedSubcontractorsList.length,
            itemBuilder: (context, index) {
              Subcontractor subcontractor = Subcontractor(
                  name: loadedSubcontractorsList[index]
                      .data()['subcontractor_name'],
                  email: loadedSubcontractorsList[index]
                      .data()['subcontractor_email'],
                  phone: loadedSubcontractorsList[index]
                      .data()['subcontractor_phone'],
                  imageURL: loadedSubcontractorsList[index]
                      .data()['subcontractor_image_url']);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(subcontractor.imageURL!),
                        ),
                      ),
                    ),
                    title: Text(subcontractor.name!),
                    subtitle: Column(
                      children: [
                        Text(subcontractor.email!),
                        Text(subcontractor.phone!)
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubcontractorModal,
        child: Icon(Icons.add),
      ),
    );
  }
}
