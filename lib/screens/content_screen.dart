import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:login_with_web/color_controller.dart';

import 'package:login_with_web/screens/add_content.dart';
import 'package:login_with_web/screens/content_controller.dart';

import 'package:login_with_web/screens/update_content.dart';

class ContenScreen extends StatefulWidget {
  const ContenScreen({Key? key}) : super(key: key);

  @override
  State<ContenScreen> createState() => _ContenScreenState();
}

class _ContenScreenState extends State<ContenScreen> {
  final controller = Get.put(ContentController());

  @override
  void initState() {
    // TODO: implement initState
    controller.getContentData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorController.buttonColor,
        title: const Text("Content"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorController.buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddContent(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: GetBuilder<ContentController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(12),
          child: controller.userContentData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return Table(
                      children: [
                        TableRow(
                          children: [
                            Text(
                              "${controller.userContentData[index].contentId}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userContentData[index].title}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userContentData[index].description}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userContentData[index].categoryId}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userContentData[index].isactive}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Image.network(
                              "${controller.userContentData[index].thumbnailUrl}",
                              width: width * 0.2,
                              height: height * 0.1,
                            ),
                            IconButton(
                              onPressed: () {
                                controller.uId =
                                    controller.userContentData[index].contentId;
                                controller.removeContentData(
                                    id: controller
                                        .userContentData[index].contentId);
                                setState(() {});
                              },
                              icon: controller.uId ==
                                          controller.userContentData[index]
                                              .contentId &&
                                      (controller.isloding ?? false)
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: CircularProgressIndicator(
                                          color: ColorController.buttonColor,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.islodings = true;
                                controller.uId =
                                    controller.userContentData[index].contentId;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateContent(
                                      userdata:
                                          controller.userContentData[index],
                                    ),
                                  ),
                                );
                                controller.islodings = false;
                              },
                              icon: controller.uId ==
                                          controller.userContentData[index]
                                              .contentId &&
                                      (controller.islodings ?? false)
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: CircularProgressIndicator(
                                          color: ColorController.buttonColor,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: controller.userContentData.length),
        ),
      ),
    );
  }
}
