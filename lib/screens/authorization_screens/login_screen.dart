import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:punch_list/screens/authorization_screens/create_account.dart';
import 'package:punch_list/screens/subcontractor/show_subcontractor_task.dart';
import '../../main.dart';
import '../contractor/projects_screen/projects_lists_screen.dart';
import 'forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  final String loginAs;
  LoginScreen({super.key, required this.loginAs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  DocumentSnapshot<Map<String, dynamic>>? userData;
  var _isLoading = false;
  String responseToken = '';

  Future<void> restartApp() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    runApp(const ProviderScope(child: PunchList()));
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  final Map<String, String> _loginData = {
    'username': '',
    'password': '',
  };

  void _loginForm() async {
    final isValid = _loginFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      _loginFormKey.currentState?.save();

      try {
        setState(() {
          _isLoading = true;
        });

        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _loginData['username']!, password: _loginData['password']!);
        final currentUser = FirebaseAuth.instance.currentUser;

        if (widget.loginAs == 'Contractor') {
          userData = await FirebaseFirestore.instance
              .collection('users')
              .doc('Category of Users')
              .collection('Contractor')
              .doc(currentUser!.uid)
              .get();
          String profile = userData!.data()!['profile'];
          if (widget.loginAs != profile) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Login credentials did not match for ${widget.loginAs}'),
              ),
            );
          } else {
            setState(() {
              _isLoading = false;
            });

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => ProjectListScreen()),
                (route) => false);
          }
        } else if (widget.loginAs == 'SubContractor') {
          userData = await FirebaseFirestore.instance
              .collection('users')
              .doc('Category of Users')
              .collection('SubContractor')
              .doc(currentUser!.uid)
              .get();
          String profile = userData!.data()!['profile'];
          if (widget.loginAs != profile) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Login credentials did not match for ${widget.loginAs}'),
              ),
            );
          } else {
            setState(() {
              _isLoading = false;
            });

            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (context) => SubcontractorTaskScreen()),
            //     (route) => false);
          }
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    print(maxHeight);
    print(maxWidth);
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
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
                    Container(
                      height: maxHeight * 0.08,
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      child: const Column(
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            'Login to continue',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: maxHeight * 0.58,
                      decoration: BoxDecoration(
                        //border: Border.all(),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColor,
                            Colors.white
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(
                          vertical: maxHeight * 0.01,
                          horizontal: maxWidth * 0.02),
                      padding: EdgeInsets.symmetric(
                          vertical: maxHeight * 0.01,
                          horizontal: maxWidth * 0.02),
                      width: double.infinity,
                      child: Form(
                        key: _loginFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: maxWidth * 0.04),
                                  child: const Text(
                                    'Username',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Enter E-mail',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Username cannot be empty';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _loginData['username'] = value;
                                      print(_loginData['username']);
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: maxHeight * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: maxWidth * 0.04),
                                    child: const Text('Password')),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01),
                                  child: SizedBox(
                                    height: maxHeight * 0.12,
                                    child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        focusNode: _passwordFocusNode,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Enter Password',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Password cannot be empty';
                                          } else if (value.length < 5) {
                                            return 'Password is too short';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _loginData['password'] = value;
                                        }),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              // height: maxHeight * 0.01,
                              child: TextButton(
                                  style: const ButtonStyle(),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return ForgotPassword(
                                            loginAs: widget.loginAs,
                                            username: _loginData['username']!);
                                      }),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Center(
                              child: SizedBox(
                                height: maxHeight * 0.07,
                                width: maxWidth * 0.7,
                                child: ElevatedButton(
                                  onPressed: _loginForm,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: maxHeight * 0.05,
                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return const CreateAccount();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text('CREATE ACCOUNT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
