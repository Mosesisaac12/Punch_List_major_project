import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        });
  }
}
