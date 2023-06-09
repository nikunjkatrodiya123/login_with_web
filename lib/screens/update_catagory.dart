import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:login_with_web/common/textfield_common.dart';
import 'package:login_with_web/model/user_model.dart';
import 'package:login_with_web/screens/catagaroy_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../color_controller.dart';

class UpdateCatagaroyScreen extends StatefulWidget {
  final User? userdata;

  const UpdateCatagaroyScreen({
    Key? key,
    this.userdata,
  }) : super(key: key);

  @override
  State<UpdateCatagaroyScreen> createState() => _UpdateCatagaroyScreenState();
}

class _UpdateCatagaroyScreenState extends State<UpdateCatagaroyScreen> {
  SharedPreferences? sharedPreferences;

  getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  final controller = Get.put(CatagaroyController());

  TextEditingController catNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  getImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  void initState() {
    if (widget.userdata != null) {
      catNameController.text = widget.userdata!.catName ?? "";
      // isActiveController.text = widget.userdata!.isactive! as String;
      descriptionController.text = widget.userdata!.description ?? "";
    }
    // TODO: implement initState
    super.initState();
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Catagory Name!';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Description!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.050,
                  ),
                  TextFieldCommon(
                    controller: isActiveController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "True-false",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'True-false';
                      }
                      return null;
                    },
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
                      putUserData(id: widget.userdata!.catId);
                      Navigator.pop(context);
                    },
                    child: const Text("Update Data"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  putUserData({int? id}) async {
    try {
      await getInstance();
      String token = sharedPreferences?.getString('token') ?? '';
      final response = await http.put(
        Uri.parse("https://878d-163-53-179-202.in.ngrok.io/api/categories/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "cat_name": catNameController.text,
          "description": descriptionController.text,
          "isactive": isActiveController.text,
          "cat_thumbnail":
              "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
        }),
      );
      if (response.statusCode == 200) {
        controller.getUserData();
        setState(() {});
      } else {
        debugPrint("Status Code -------------->>> ${response.body}");
      }
    } finally {}
  }
}
