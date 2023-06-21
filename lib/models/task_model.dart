import 'dart:io';

class Tasks {
  final String name;
  final String? subcontractor;
  final String description;
  final File? image;
  final ImageURL;

  Tasks(
      {required this.name,
      this.subcontractor,
      required this.description,
      this.image,
      this.ImageURL});
}
