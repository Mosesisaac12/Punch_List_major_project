import 'dart:io';

class Subcontractor {
  final String? name;
  final String? email;
  final String? phone;
  final File? image;
  final String? imageURL;

  Subcontractor(
      {required this.name,
      required this.email,
      this.phone,
      this.image,
      this.imageURL});
}
