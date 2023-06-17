import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/project_model.dart';

class NewProjectNotifier extends StateNotifier<List<Project>> {
  NewProjectNotifier() : super(const []);

  void addProject(Project project) {
    final newProject = Project(
      name: project.name,
      address: project.address,
      zipCode: project.zipCode,
      lotBlockSection: project.lotBlockSection,
      image: project.image,
      location: project.location,
    );
    state = [newProject, ...state];
  }
}

final newProjectProvider =
    StateNotifierProvider<NewProjectNotifier, List<Project>>(
        (ref) => NewProjectNotifier());
