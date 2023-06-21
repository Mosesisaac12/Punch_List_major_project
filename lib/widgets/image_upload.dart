import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key, required this.onTakenImage});

  final void Function(File takenImage) onTakenImage;

  @override
  State<ImageUpload> createState() => _ImageUpload();
}

class _ImageUpload extends State<ImageUpload> {
  File? _takenImageFile;
  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    print('This is a picked Image${pickedImage}');

    if (pickedImage == null) {
      print('picked image null');
    }

    setState(() {
      _takenImageFile = File(pickedImage!.path);
    });

    widget.onTakenImage(_takenImageFile!);
  }

  Future<void> _uploadPicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _takenImageFile = File(pickedImage.path);
    });

    widget.onTakenImage(_takenImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _takenImageFile != null ? FileImage(_takenImageFile!) : null,
        ),
        TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(
              Icons.camera_alt_rounded,
            ),
            label: const Text(
              'Take Image',
            )),
        TextButton.icon(
          icon: const Icon(Icons.image_rounded),
          label: const Text('Upload Picture'),
          onPressed: _uploadPicture,
        ),
      ],
    );
  }
}
