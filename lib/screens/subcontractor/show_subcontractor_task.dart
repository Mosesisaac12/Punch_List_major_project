import 'package:flutter/material.dart';
import '../../models/subcontractor_task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:punch_list/providers/tasks/create_task.dart';

class SubcontractorTaskScreen extends ConsumerStatefulWidget {
  const SubcontractorTaskScreen({super.key});

  @override
  ConsumerState<SubcontractorTaskScreen> createState() =>
      _SubcontractorTaskScreenState();
}

class _SubcontractorTaskScreenState
    extends ConsumerState<SubcontractorTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subcontractor Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading:
                task.image == null ? Text('No image') : Image.file(task.image!),
            title: Text(task.name),
            subtitle: Text(task.description),
            // trailing: Checkbox(
            //   value: task.isComplete,
            //   onChanged: (value) {
            //     // TODO: Implement task completion logic
            //   },
            // ),
            // onTap: () {
            //   // TODO: Navigate to task details screen
            // },
          );
        },
      ),
    );
  }
}
