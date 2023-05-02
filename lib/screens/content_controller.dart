import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'model/content_user.dart';

class ContentController extends GetxController {
  SharedPreferences? sharedPreferences;
  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();

  }

  List<ContentUser> userContentData = [];
  bool? isloding;
  bool? islodings;
  int? uId;
  removeContentData({int? id}) async {
    isloding = true;
    try {
      getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      final response = await http.delete(
        Uri.parse("https://d4e6-163-53-179-202.in.ngrok.io/api/contents/$id"),
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        log("Log  -------------->>> ");

        getContentData();
        update();
        isloding = false;
      } else {
        debugPrint("Status Code -------------->>> ${response.body}");
      }
    } catch (e) {
      debugPrint("Log dvbkjnblgmn -------------->>> $e");
    } finally {}
  }

  getContentData() async {
    try {
      getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      http.Response response = await http.get(
        Uri.parse("https://582b-103-251-19-55.in.ngrok.io/api/contents"),
        headers: {"Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        userContentData = (jsonDecode(response.body) as List?)!
            .map((dynamic e) => ContentUser.fromJson(e))
            .toList();
        update();
      } else {
        log("Status Code -------------->>> ${response.body}");
      }
    } catch (e) {
      log("Log  -------------->>> $e");
    } finally {}
  }
}
