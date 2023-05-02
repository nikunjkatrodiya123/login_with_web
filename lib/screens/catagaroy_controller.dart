import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:login_with_web/model/user_model.dart';
import 'package:login_with_web/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatagaroyController extends GetxController {
  SharedPreferences? sharedPreferences;

  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  bool? isloding;
  bool? islodings;
  int? uId;
  List<User> userData = [];

  removeUserData({int? id}) async {
    isloding = true;
    try {
      getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      final response = await http.delete(
        Uri.parse("https://878d-163-53-179-202.in.ngrok.io/api/categories/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        log("Log  -------------->>> ");

        getUserData();
        isloding = false;
      } else {
        debugPrint("Status Code -------------->>> ${response.body}");
      }
    } catch (e) {
      debugPrint("Log dvbkjnblgmn -------------->>> $e");
    } finally {}
  }

  getUserData() async {
    try {
      getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      final response = await http.get(
        Uri.parse("https://878d-163-53-179-202.in.ngrok.io/api/categories"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        userData = (jsonDecode(response.body) as List?)!
            .map((dynamic e) => User.fromJson(e))
            .toList();

        update();
      } else {
        log("Status Code -------------->>> ${response.body}");
      }
    } catch (e) {
      log("Log  -------------->>> $e");
      if (e == "failed to authenticate token") {
        Get.offAll(const SignUpScreen());
      }
    }
  }
}
