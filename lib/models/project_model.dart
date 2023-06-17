import 'dart:io';

class ProjectLocation {
  final double latitude;
  final double longitude;
  final String address;
  ProjectLocation(
      {required this.latitude, required this.longitude, required this.address});
}

class Project {
  final String? name;
  final String? address;
  final String? lotBlockSection;
  final String? zipCode;
  final File? image;
  final ProjectLocation? location;

  Project({
    required this.name,
    required this.address,
    required this.lotBlockSection,
    required this.zipCode,
    required this.image,
    this.location,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
      address: json['address'],
      lotBlockSection: json['lot_block_section'],
      zipCode: json['zip_code'],
      image: json['images'],
      location: ProjectLocation(
        latitude: json['location']['latitude'],
        longitude: json['location']['longitude'],
        address: json['location']['address'],
      ),
    );
  }
}
