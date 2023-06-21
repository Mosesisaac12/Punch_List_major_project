import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task_model.dart';

class CreateTaskNotifier extends StateNotifier<List<Tasks>> {
  CreateTaskNotifier() : super([]);

  void addtask(Tasks task) {
    final newTask = Tasks(
      name: task.name,
      subcontractor: task.subcontractor,
      description: task.description,
      image: task.image,
    );
    state = [newTask, ...state];
  }
}

final taskProvider =
    StateNotifierProvider<CreateTaskNotifier, List<Tasks>>((ref) {
  return CreateTaskNotifier();
});
