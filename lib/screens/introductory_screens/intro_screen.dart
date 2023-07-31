import 'package:flutter/material.dart';
import 'package:punch_list/screens/authorization_screens/create_account.dart';
import 'package:punch_list/screens/authorization_screens/login_screen.dart';

class IntroScreen extends StatelessWidget {
  String? loginAs = '';

  IntroScreen({super.key, this.loginAs});
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                elevation: 5,
                child: Image.asset(
                  'assets/images/3.png',
                  height: maxHeight * 0.23,
                  width: maxWidth * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                loginAs = 'Admin';
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return LoginScreen(
                    loginAs: loginAs!,
                  );
                }));
                // TODO: Implement admin login logic
              },
              child: const Text('Login as Admin'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                loginAs = 'Contractor';
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LoginScreen(
                    loginAs: loginAs!,
                  );
                }));
                // TODO: Implement contractor login logic
              },
              child: const Text('Login as Contractor'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                loginAs = 'SubContractor';
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LoginScreen(
                    loginAs: loginAs!,
                  );
                }));
                // TODO: Implement subcontractor login logic
              },
              child: const Text('Login as Subcontractor'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const CreateAccount();
                }));
                // TODO: Navigate to create account page
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
