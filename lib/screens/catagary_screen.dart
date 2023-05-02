import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_with_web/color_controller.dart';
import 'package:login_with_web/screens/add_catagory.dart';
import 'package:login_with_web/screens/catagaroy_controller.dart';

import 'update_catagory.dart';

class CatagaroyScreen extends StatefulWidget {
  const CatagaroyScreen({Key? key}) : super(key: key);

  @override
  State<CatagaroyScreen> createState() => _CatagaroyScreenState();
}

class _CatagaroyScreenState extends State<CatagaroyScreen> {
  final controller = Get.put(CatagaroyController());

  @override
  void initState() {
    // TODO: implement initState
    controller.getUserData();
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
        title: const Text("Catagaroy"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorController.buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCatagory(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: GetBuilder<CatagaroyController>(
        builder: (controller) => Padding(
          padding: const EdgeInsets.all(12),
          child: controller.userData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return Table(
                      children: [
                        TableRow(
                          children: [
                            Text(
                              "${controller.userData[index].catId}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userData[index].catName}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userData[index].description}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              "${controller.userData[index].isactive}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Image.network(
                              "${controller.userData[index].catThumbnail}",
                              width: width * 0.2,
                              height: height * 0.1,
                            ),
                            IconButton(
                              onPressed: () {
                                controller.uId =
                                    controller.userData[index].catId;
                                controller.removeUserData(
                                    id: controller.userData[index].catId);
                                setState(() {});
                              },
                              icon: controller.uId ==
                                          controller.userData[index].catId &&
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
                                    controller.userData[index].catId;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateCatagaroyScreen(
                                      userdata: controller.userData[index],
                                    ),
                                  ),
                                );
                                controller.islodings = false;
                              },
                              icon: controller.uId ==
                                          controller.userData[index].catId &&
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
                  itemCount: controller.userData.length),
        ),
      ),
    );
  }
}
