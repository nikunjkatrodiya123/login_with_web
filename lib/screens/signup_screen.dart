import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_with_web/color_controller.dart';
import 'package:login_with_web/common/textfield_common.dart';
import 'package:login_with_web/screens/web_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SharedPreferences? sharedPreferences;
  TextEditingController emailController =
      TextEditingController(text: 'nikunj@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: '1234');
  TextEditingController userNameController =
      TextEditingController(text: 'Anand');

  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getInstance();
    super.initState();
  }

  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  setLoginData(String getToken) async {
    await sharedPreferences!.setString('login', "token");
  }

  setData() async {
    await sharedPreferences!.setString(
      'loginData',
      jsonEncode({
        "email": emailController.text,
        "username": userNameController.text,
        "password": passwordController.text,
      }),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: height * 0.050,
                  ),
                  Container(
                    height: width * 0.3,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      color: ColorController.buttonColor,
                      borderRadius: BorderRadius.circular(width * 0.15),
                      //border: Border.all(color: Colors.black)
                    ),
                    child: ClipOval(
                      child: Icon(
                        Icons.person,
                        size: width * 0.3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    "Welcome ",
                    style: TextStyle(
                        fontSize: width * 0.1, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.040,
                  ),
                  TextFieldCommon(
                    controller: userNameController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "UserName",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid User Name!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: emailController,
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: "E-Mail",
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: passwordController,
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Password",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid password!';
                      }
                      return null;
                    },
                  ),
                  //text input

                  SizedBox(
                    height: height * 0.050,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorController.buttonColor),
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    onPressed: () {
                      submit();
                      login();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      setData();
    });

  }

  Future<void> login() async {
    final url =
        Uri.parse('https://d4e6-163-53-179-202.in.ngrok.io/api/users/login');
    final response = await http.post(url, body: {
      'user_name': userNameController.text,
      'user_password': passwordController.text,
    });
    debugPrint('.................................${response.statusCode}');
    debugPrint('.................................${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint('.................................${response.body}');
      sharedPreferences?.setString('token', data['token']);

      String token = sharedPreferences?.getString('token') ?? '';
      if(token.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const WebScreen(),
            ),
                (route) => false);}

        debugPrint('no data found');

      // handle the response data here
    } else {
      throw Exception('Failed to login');
    }
  }
}
