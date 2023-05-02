import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_with_web/color_controller.dart';
import 'package:login_with_web/common/textfield_common.dart';
import 'package:login_with_web/screens/catagaroy_controller.dart';
import 'package:login_with_web/screens/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCatagory extends StatefulWidget {
  const AddCatagory({Key? key}) : super(key: key);

  @override
  State<AddCatagory> createState() => _AddCatagoryState();
}

class _AddCatagoryState extends State<AddCatagory> {
  List<User> userData = [];
  TextEditingController catNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();
  final controller = Get.put(CatagaroyController());
  SharedPreferences? sharedPreferences;
  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();

  }

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
                    controller: catNameController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Catagaroy",
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
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorController.buttonColor),
                    ),
                    onPressed: () {
                      putUserData();
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

  putUserData() async {
    try {
      getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      final response = await http.post(
        Uri.parse(
            "https://d4e6-163-53-179-202.in.ngrok.io/api/categories/create"),
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"},
        body: jsonEncode({
          "cat_name": catNameController.text,
          "description": descriptionController.text,
          "isactive": isActiveController.text,
          "cat_thumbnail":
              "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
        }),
      );
      if (response.statusCode == 200) {
        log("Status Code -------------->>> ${response.body}");
        controller.getUserData();
        setState(() {});
      } else {
        debugPrint("Status Code -------------->>> ${response.body}");
      }
    } catch (e) {
      debugPrint("Log  -------------->>> $e");
    } finally {}
  }
}
