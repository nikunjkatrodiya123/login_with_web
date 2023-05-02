import 'package:flutter/material.dart';
import 'package:login_with_web/screens/signup_screen.dart';
import 'package:login_with_web/screens/home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    getInstance();
    super.initState();

  }
  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: sharedPreferences?.getString('token')?.isNotEmpty??false?const HomeScreen():const SignUpScreen(),
    );
  }
}
