import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:punch_list/screens/introductory_screens/intro_screen.dart';
import 'package:punch_list/widgets/user_image_picker.dart';
import 'login_screen.dart';
import 'email_otp.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _signupFormKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool isAuthenticating = false;

  final Map<String, dynamic> _signupData = {
    'username': '',
    'fullName': '',
    'countryCode': 91,
    'mobileNo': '',
    'password': '',
    'confirmPassword': '',
    'group': ''
  };

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'SubContractor',
      'label': 'SubContractor',
      'icon': const Icon(Icons.person),
    },
    {
      'value': 'Contractor',
      'label': 'Contractor',
      'icon': const Icon(Icons.home_repair_service),
      'textStyle': const TextStyle(color: Colors.red),
    },
    {
      'value': 'starValue',
      'label': 'Admin',
      'icon': const Icon(Icons.man_2_sharp),
    },
  ];
  final _passwordController = TextEditingController();

  var _isLoading = false;

  final _fullNameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // Future<dynamic> _onFailure() {
  //   return showDialog(
  //       // useSafeArea: true,
  //       context: context,
  //       builder: (ctx) {
  //         return AlertDialog(
  //           title: Text('An Error occurred'),
  //           content: Text('Server Error'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Okay'),
  //             )
  //           ],
  //         );
  //       });
  // }
  String username = '';

  void _onSuccess() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EmailOtp(username, _signupData['group']);
    }));
  }

  @override
  void dispose() {
    _fullNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isValid = _signupFormKey.currentState?.validate();
    if (!isValid! || _selectedImage == null) {
      return;
    }
    _signupFormKey.currentState?.save();
    try {
      setState(() {
        isAuthenticating = true;
      });
      final _userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _signupData['username'], password: _signupData['password']);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${_userCredentials.user!.uid}.jpg');

      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      print(imageUrl);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredentials.user!.uid)
          .set({
        'name': _signupData['fullName'],
        'profile': _signupData['group'],
        'mobile_no': _signupData['mobileNo'],
        'image_url': imageUrl
      });

      print(_userCredentials);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return IntroScreen();
      }));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed')));
      }
      setState(() {
        isAuthenticating = false;
      });
    }

    // setState(() {
    //   _isLoading = true;
    // });

    // final url = Uri.parse('http://104.236.1.97:5000/register/');
    // try {
    //   final response = await post(
    //     url,
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode(
    //       {
    //         'username': _signupData['username'],
    //         'fullname': _signupData['fullName'],
    //         'country_code': _signupData['countryCode'],
    //         'mobile_no': _signupData['mobileNo'],
    //         'password': _signupData['password'],
    //         'confirm_password': _signupData['confirmPassword'],
    //         'group': _signupData['group'],
    //       },
    //     ),
    //   );
    //   final responseData = json.decode(response.body);
    //   if (response.statusCode >= 200 && response.statusCode < 300) {
    //     final responseMessage = responseData['message'];

    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(responseMessage),
    //       backgroundColor: Colors.green,
    //     ));
    //     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //       return EmailOtp(_signupData['username'], _signupData['group']);
    //     }));
    //   } else {
    //     print(responseData);
    //     setState(() {
    //       _isLoading = false;
    //     });

    //     final responseMessage = responseData['message'];

    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(responseMessage),
    //       backgroundColor: Colors.red,
    //     ));
    //   }
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Something went wrong, please check back later'),
    //     backgroundColor: Colors.red,
    //   ));
    // } // final responseData = json.decode(response);

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // Text(
                    //   'Create Account',
                    //   style: TextStyle(fontSize: 26),
                    // ),
                    Container(
                      height: maxHeight * 1.2,
                      margin: EdgeInsets.symmetric(
                          vertical: maxHeight * 0.01,
                          horizontal: maxWidth * 0.02),
                      padding: EdgeInsets.symmetric(
                          vertical: maxHeight * 0.01,
                          horizontal: maxWidth * 0.03),
                      decoration: BoxDecoration(
                          // border: Border.all(),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).primaryColor,
                                Colors.white
                              ]),
                          borderRadius: BorderRadius.circular(25)),
                      child: Form(
                        key: _signupFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01,
                                      horizontal: maxWidth * 0.04),
                                  child: const Text('Username'),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_fullNameFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter your E-mail',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username cannot be empty';
                                    } else if (!value.contains('@')) {
                                      return 'Invalid Email';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _signupData['username'] = value;
                                    username = value;
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01,
                                      horizontal: maxWidth * 0.04),
                                  child: const Text('Full Name'),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _fullNameFocusNode,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_phoneNumberFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Full Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Name cannot be empty';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _signupData['fullName'] = value;
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01,
                                      horizontal: maxWidth * 0.04),
                                  child: const Text('Phone Number'),
                                ),
                                IntlPhoneField(
                                  // controller: _intialCountryCodeController,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _phoneNumberFocusNode,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Phone Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  initialCountryCode: 'IN',
                                  onChanged: (phone) {
                                    print(phone.number);

                                    _signupData['mobileNo'] = phone.number;
                                  },
                                  onSaved: (phone) {},
                                  onCountryChanged: (country) {
                                    print(country.code);
                                    print(country.dialCode);
                                    int countryCode =
                                        int.parse(country.dialCode);

                                    _signupData['countryCode'] = countryCode;
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: maxHeight * 0.01,
                                        horizontal: maxWidth * 0.04),
                                    child: const Text('Password')),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: maxHeight * 0.01,
                                  ),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                          _confirmPasswordFocusNode);
                                    },
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      _signupData['password'] = value;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01,
                                      horizontal: maxWidth * 0.05),
                                  child: FlutterPwValidator(
                                    controller: _passwordController,
                                    minLength: 7,
                                    uppercaseCharCount: 1,
                                    numericCharCount: 1,
                                    specialCharCount: 1,
                                    width: maxWidth * 0.8,
                                    height: maxHeight * 0.1,
                                    defaultColor: Colors.white,
                                    successColor: Colors.green,
                                    onSuccess: () {
                                      print("MATCHED");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Password Strength: Excellent"),
                                        ),
                                      );
                                    },
                                    onFail: () {
                                      print("Inapprpriate password");
                                    },
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: maxHeight * 0.01,
                                      horizontal: maxWidth * 0.04),
                                  child: const Text('Confirm Password'),
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  focusNode: _confirmPasswordFocusNode,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Confirm Password',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Confirm Password cannot be empty';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _signupData['confirmPassword'] = value;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: maxHeight * 0.1,
                              width: double.infinity,
                              child: SelectFormField(
                                type: SelectFormFieldType
                                    .dropdown, // or can be dialog
                                initialValue: 'Subcontractor',
                                icon: const Icon(Icons.construction),
                                labelText: 'Profile',
                                items: _items,
                                onChanged: (val) {
                                  _signupData['group'] = val;
                                  print(val);
                                },
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: maxHeight * 0.07,
                                width: maxWidth * 0.8,
                                child: isAuthenticating
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ElevatedButton(
                                        onPressed: _saveForm,
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            shape: const StadiumBorder()),
                                        child: const Text('Signup'),
                                      ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  child: const Text('Login'),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return IntroScreen();
                                    }));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
