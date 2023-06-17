import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task_model.dart';

class CreateTaskNotifier extends StateNotifier<List<Task>> {
  CreateTaskNotifier() : super([]);

  void addtask(Task task) {
    final newTask = Task(
      name: task.name,
      subcontractor: task.subcontractor,
      description: task.description,
      image: task.image,
    );
    state = [newTask, ...state];
  }
}

final taskProvider =
    StateNotifierProvider<CreateTaskNotifier, List<Task>>((ref) {
  return CreateTaskNotifier();
});
