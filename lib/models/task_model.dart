import 'dart:io';

class Task {
  final String name;
  final String subcontractor;
  final String description;
  final File? image;

  Task({
    required this.name,
    required this.subcontractor,
    required this.description,
    required this.image,
  });
}
