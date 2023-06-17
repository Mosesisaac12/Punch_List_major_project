import 'package:flutter/material.dart';

class CreateNewPassword extends StatefulWidget {
  final String _username;
  const CreateNewPassword(this._username, {super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final Map<String, String> _NewPasswordData = {
    'password': '',
    'confirmNewPassword': ''
  };

  String _responseMessage = '';

  // Future<void> _sendNewPasswordScreen() async {
  //   try {
  //     await Provider.of<CreateNewPasswordDataProvider>(context, listen: false)
  //         .sendNewPasswordProvider(
  //             widget._username,
  //             _NewPasswordData['password']!,
  //             _NewPasswordData['confirmNewPassword']!)
  //         .then((response) {
  //       if (response.statusCode >= 200 && response.statusCode < 300) {
  //         setState(() {
  //           _responseMessage = 'OTP verification successful';
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(_responseMessage),
  //           backgroundColor: Colors.green,
  //         ));
  //       } else {
  //         setState(() {
  //           _responseMessage = 'Unsuccessful verfication,Please check OTP';
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(_responseMessage),
  //           backgroundColor: Colors.red,
  //         ));
  //       }
  //     });
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          height: 700,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  'Create New Password',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('New Password'),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Create New Password',
                        fillColor: const Color.fromRGBO(0, 0, 0, 0.1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        _NewPasswordData['password'] = value;
                      },
                    ),
                    const Text('Confirm New Password'),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(0, 0, 0, 0.1),
                        filled: true,
                        hintText: 'Confirm New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        _NewPasswordData['confirmNewPassword'] = value;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 300,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Text('Submit'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
