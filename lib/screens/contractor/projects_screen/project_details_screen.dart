import 'package:flutter/material.dart';
import 'package:punch_list/screens/contractor/tasks_screens/show_tasks_screen.dart';
import '../../../models/project_model.dart';

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key, required this.project});
  final Project project;

  String? get locationImage {
    if (project.location == null) {
      return null;
    }
    final lat = project.location!.latitude;
    final long = project.location!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$long&key=YOUR_API_KEY&signature=YOUR_SIGNATURE';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Image.file(
              project.image!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              'Location on Google Maps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              // Replace this with your Google Maps widget or integration
              width: double.infinity,
              height: 200,
              color: Colors.grey,
              child: locationImage == null
                  ? Text('No location chosen')
                  : Image.network(locationImage!),
            ),
            const SizedBox(height: 16),
            Text(
              'Address: ${project.address}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lot Block Section: ${project.lotBlockSection}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Zip Code: ${project.zipCode}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ShowTasksScreen();
                }));
              },
              child: const Text('Show Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
