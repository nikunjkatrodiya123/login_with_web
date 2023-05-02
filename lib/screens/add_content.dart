import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:login_with_web/color_controller.dart';
import 'package:login_with_web/common/textfield_common.dart';
import 'package:login_with_web/model/content_user.dart';
import 'package:login_with_web/screens/content_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContent extends StatefulWidget {
  const AddContent({Key? key}) : super(key: key);

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  SharedPreferences? sharedPreferences;

  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  final controller = Get.put(ContentController());
  List<ContentUser> userContentData = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();
  TextEditingController cIdController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  getImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        height: width * 0.4,
                        width: width * 0.4,
                        color: ColorController.buttonColor,
                        child: image == null
                            ? const Icon(Icons.image)
                            : Image.file(
                                File(image!.path),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: nameController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Title",
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: descriptionController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Description",
                    minLines: 3,
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: isActiveController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "True-false",
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: cIdController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Catagaroy ID",
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorController.buttonColor),
                    ),
                    onPressed: () {
                      addUserContent();
                      setState(() {});

                      Navigator.pop(context);
                    },
                    child: const Text("Add Data"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addUserContent() async {
    try {
      await getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      final response = await http.post(
        Uri.parse(
            "https://878d-163-53-179-202.in.ngrok.io/api/contents/create"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "title": nameController.text,
          "description": descriptionController.text,
          "isactive": isActiveController.text,
          "thumbnail_url":
              "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
          "views": "girhgihi",
          "category_id": cIdController.text,
          "content_url":
              "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
        }),
      );
      if (response.statusCode == 200) {
        log("Status Code -------------->>> ${response.body}");

        controller.getContentData();

        setState(() {});
      } else {
        debugPrint("Status Code -------------->>> ${response.body}");
      }
    } catch (e) {
      debugPrint("Log  -------------->>> $e");
    } finally {}
  }
}
