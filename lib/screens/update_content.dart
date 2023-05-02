import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:login_with_web/color_controller.dart';
import 'package:login_with_web/common/textfield_common.dart';
import 'package:login_with_web/screens/content_controller.dart';
import 'package:login_with_web/screens/model/content_user.dart';

class UpdateContent extends StatefulWidget {
  final ContentUser? userdata;

  const UpdateContent({Key? key, this.userdata}) : super(key: key);

  @override
  State<UpdateContent> createState() => _UpdateContentState();
}

class _UpdateContentState extends State<UpdateContent> {
  final controller = Get.put(ContentController());
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController isActiveController = TextEditingController();
  TextEditingController cIdController = TextEditingController();
  bool? islodings;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  getImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  void initState() {
    if (widget.userdata != null) {
      nameController.text = widget.userdata!.title ?? "";
      isActiveController.text = widget.userdata!.isactive! as String;
      descriptionController.text = widget.userdata!.description ?? "";
      cIdController.text = widget.userdata!.contentId as String ?? "";
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
                      putUserData(id: widget.userdata!.contentId);
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
      final response = await http.put(
        Uri.parse("https://582b-103-251-19-55.in.ngrok.io/api/contents/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": nameController.text,
          "description": descriptionController.text,
          "isactive": isActiveController.text,
          "content_id": cIdController.text,
          "content_url":
              " https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
          "cat_thumbnail":
              "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
        }),
      );
      if (response.statusCode == 200) {
        controller.getContentData();
        setState(() {});
      } else {
        debugPrint("Status Code -------------->>> ${response.body}");
      }
    } finally {}
  }
}
