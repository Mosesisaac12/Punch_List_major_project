// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:punch_list/providers/tasks/create_task.dart';

// class SubcontractorTaskScreen extends ConsumerStatefulWidget {
//   const SubcontractorTaskScreen({super.key});

//   @override
//   ConsumerState<SubcontractorTaskScreen> createState() =>
//       _SubcontractorTaskScreenState();
// }

// class _SubcontractorTaskScreenState
//     extends ConsumerState<SubcontractorTaskScreen> {
//   void init() {
//     super.initState();
//     final currentUser = FirebaseAuth.instance.currentUser;
//     userData = FirebaseFirestore.instance
//         .collection('users')
//         .doc('${currentUser!.uid}')
//         .get();
//   }

//   late final dynamic userData;
//   @override
//   Widget build(BuildContext context) {
//     final tasks = ref.watch(taskProvider);
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Subcontractor Tasks'),
//         ),
//         body: StreamBuilder(
//             stream: FirebaseFirestore.collection('').doc(''),
//             builder: (context, snapshot) {
//               return ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   return ListTile(
//                     leading: task.image == null
//                         ? Text('No image')
//                         : Image.file(task.image!),
//                     title: Text(task.name),
//                     subtitle: Text(task.description),
//                     // trailing: Checkbox(
//                     //   value: task.isComplete,
//                     //   onChanged: (value) {
//                     //     // TODO: Implement task completion logic
//                     //   },
//                     // ),
//                     // onTap: () {
//                     //   // TODO: Navigate to task details screen
//                     // },
//                   );
//                 },
//               );
//             }));
//   }
// }
