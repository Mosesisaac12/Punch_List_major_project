import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:punch_list/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:punch_list/screens/contractor/projects_screen/create_new_project_screen.dart';
import 'package:punch_list/screens/contractor/projects_screen/projects_lists_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:punch_list/screens/contractor/show_subcontractor_screens/subcontractor_list_screen.dart';
import 'package:punch_list/screens/contractor/tasks_screens/show_tasks_screen.dart';
import 'screens/authorization_screens/create_account.dart';
import 'screens/introductory_screens/intro_screen.dart';

//Add Api Key in Androidmanifest, Appdelegate.swift file and project screens

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: PunchList()),
  );
}

class PunchList extends StatelessWidget {
  const PunchList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: ThemeData.light().textTheme.copyWith(
              labelSmall: const TextStyle(color: Colors.white),
              displayMedium: const TextStyle(fontSize: 20, color: Colors.black),
              headlineMedium:
                  const TextStyle(fontSize: 28, color: Colors.black)),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (snapshot.hasData) {
                return ProjectListScreen();
              }
              return IntroScreen();
            }));
  }
}
