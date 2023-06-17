import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  final ImageProvider _defaultImage =
      const AssetImage('assets/images/blank_user.png');

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
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
      _pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!)
              : _defaultImage,
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.photo,
            color: Colors.white,
          ),
          label: const Text(
            'Upload Picture',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _uploadPicture,
        ),
        TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(
              Icons.camera_enhance_sharp,
              color: Colors.white,
            ),
            label: const Text(
              'Add Image',
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
