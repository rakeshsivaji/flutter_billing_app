import 'package:billing_app/Models/lineshow_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Lines extends StatefulWidget {
  const Lines({super.key});

  @override
  State<Lines> createState() => _LinesState();
}

class _LinesState extends State<Lines> {
  var commonController = Get.put(CommonController());
  final TextEditingController search = TextEditingController();

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.deepPurple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

// Obx(() {     }),
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(120, 89, 207, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed('/adminhome');
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'அனைத்து வழிகளும்',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // await commonController.getEmployee(
                                  //     withLoader: true);
                                  await commonController.getAllEmployee();
                                  await commonController.getCollectionUser();
                                  Get.toNamed('/stocklinereport');
                                },
                                child: const Text(
                                  'அறிக்கைகள்',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   children: [
            //     CustomAppBar(
            //       text: 'அனைத்து வழிகளும்',
            //       path: '/adminhome',
            //     ),
            //     Expanded(
            //       child: Text(
            //         "அறிக்கைகள்",
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     )
            //   ],
            // ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await commonController.getlineshow();

                            Get.toNamed('/createstockline');
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(120, 89, 207, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset('assets/images/lineadd.png'),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'வழியை உருவாக்க',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Column(
                          children: [
                            Container(
                              child: Obx(
                                () {
                                  final lineshow = commonController
                                      .lineshowmodel.value!.data;

                                  if (lineshow.isEmpty) {
                                    return const Text('வழிகள் இல்லை');
                                  }
                                  return ListView.builder(
                                    itemCount: lineshow.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: ((context, index) {
                                      return buildCard(lineshow[index]);
                                    }),
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildCard(Datum data) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(120, 89, 207, 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(19, 19, 19, 0.1),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/pathroad.png',
                width: 28,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.employeeCount.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const SizedBox(
                width: 20.0,
              ),
              InkWell(
                onTap: () async {
                  await commonController.getlineedit(data.lineId.toString());
                  Get.toNamed('/editstockline',
                      arguments: {'id': data.lineId.toString()});
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Image.asset(
                    'assets/images/edit.png',
                    width: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
