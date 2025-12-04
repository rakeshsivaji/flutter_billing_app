import 'package:billing_app/Models/userline_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Stockline extends StatefulWidget {
  const Stockline({Key? key}) : super(key: key);

  @override
  State<Stockline> createState() => _StocklineState();
}

class _StocklineState extends State<Stockline> {
  var commonController = Get.put(CommonController());
  int id = 0;
  String lineid = '';

  String completed = '';

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

  Future<void> refreshvalue() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    commonController.getuserline();
    print('Value');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/home');
        return true;
      },
      child: RefreshIndicator(
        onRefresh: refreshvalue,
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
                                  Get.toNamed('/home');
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
                          const Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'அனைத்து வழிகளும்',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
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
                          Obx(
                            () {
                              final lineshow =
                                  commonController.userlinemodel.value?.data;

                              if (lineshow == null || lineshow.isEmpty) {
                                return const Text('வழிகள் இல்லை');
                              }
                              return ListView.builder(
                                itemCount: lineshow.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemBuilder: ((context, index) {
                                  return buildCardItem(lineshow[index]);
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildCardItem(Datum data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(120, 89, 207, 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(19, 19, 19, 0.1),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pathroad.png',
              width: 30,
              height: 35,
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Text(
                data.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (data.start == true) ...[
                    InkWell(
                      onTap: () async {
                        if (data.isStart == true) {
                          await commonController
                              .getuserlinereport(data.lineId.toString());
                          Get.toNamed('/newstock', arguments: {
                            'id': data.lineId.toString(),
                            'status': true
                          });
                        } else {
                          _PopupMenu1(data.lineId.toString());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 7),
                        width: 110,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(120, 89, 207, 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/Power.png',
                                height: 15,
                                width: 25,
                              ),
                              Center(
                                child: Text(
                                  data.isStart ? 'தொடரவும்' : 'தொடங்கு',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ] else if (data.completed) ...[
                    InkWell(
                      onTap: () async {
                        await commonController
                            .getuserlinereport(data.lineId.toString());
                        Get.toNamed('/newstock', arguments: {
                          'id': data.lineId.toString(),
                          'status': false
                        });
                      },
                      child: Container(
                        child: const Text(
                          'முடிக்கப்பட்டது',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color.fromRGBO(120, 89, 207, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  ] else if (data.lineStatus == 'Pending') ...[
                    Text(
                      data.startedBy + ' ஆல் தொடங்கப்பட்டது',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color.fromRGBO(120, 89, 207, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _PopupMenu1(String id) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'இந்த வழியை நீங்கள் தொடர வேண்டுமா ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'ரத்து செய்',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          submit(id);
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'ஆம்',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 5,
              height: 30,
              width: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/images/closeicon.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit(String id) async {
    // print(lineid);
    dynamic response = await CommonService().lineStart(id);
    if (response['status'] == 1) {
      showToast(response['message']);
      await commonController.getuserlinereport(id.toString());
      Get.toNamed('/newstock', arguments: {'id': id, 'status': true});
    } else {
      showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
    }
  }
}
