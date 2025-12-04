import 'package:billing_app/Models/notification_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Announce extends StatefulWidget {
  const Announce({super.key});

  @override
  State<Announce> createState() => _AnnounceState();
}

class _AnnounceState extends State<Announce> {
  var commonController = Get.put(CommonController());
  Future<void> refreshvalue() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await commonController.getNotification();
    print('Value');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/home');
        return false;
      },
      child: RefreshIndicator(
        onRefresh: refreshvalue,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          appBar: AppBar(
            leading: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigator.pushReplacementNamed(context, '/home');
                  Get.toNamed('/home');
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: const Text(
              'அறிவிப்பு',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
            titleSpacing: -2.0,
          ),
          body: Obx(
            () {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        if (commonController.notification == true) ...[
                          ListView.builder(
                            itemCount: commonController
                                .notificationModel.value!.data.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemBuilder: ((context, index) {
                              return buildCards(commonController
                                  .notificationModel.value!.data[index]);
                            }),
                          ),
                        ] else ...[
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(child: Text('வேறு தகவல்கள் இல்லை'))
                        ],
                        // Column(
                        //   children: [
                        //     Obx(() {
                        //       final notify =
                        //           commonController.notificationModel.value?.data;
                        //       if (notify == null ||
                        //           notify.isEmpty ||
                        //           commonController.notification == false) {
                        //         return Center(child: Text('வேறு தகவல்கள் இல்லை'));
                        //       } else {
                        //         return ListView.builder(
                        //           itemCount: notify.length,
                        //           shrinkWrap: true,
                        //           physics: NeverScrollableScrollPhysics(),
                        //           padding: EdgeInsets.all(0),
                        //           itemBuilder: ((context, index) {
                        //             return buildCards(notify[index]);
                        //           }),
                        //         );
                        //       }
                        //     }),
                        //     // buildCards(),
                        //     SizedBox(
                        //       height: 20.0,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  GestureDetector buildCards(Datum data) {
    return GestureDetector(
      onTap: () {
        _PopupMenu(data.orderId.toString());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            )),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        data.storeName.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SelectableText(
                        data.pathName.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SelectableText(
                        data.storeAddress.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        data.ownerName.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                      SelectableText(
                        data.ownerPhone,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: data.status == 'Bill Enterd'
                    ? const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Color.fromRGBO(216, 253, 203, 1),
                      )
                    : const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Color.fromRGBO(255, 224, 224, 1),
                      ),
                child: Center(
                  child: Text(
                    data.status.toString(),
                    style: TextStyle(
                        color: data.status == 'Bill Enterd'
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _PopupMenu(String id) {
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
                  const Text(
                    'நீங்கள் தொகையை செலுத்த வேண்டுமா?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
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
                              'பின்னர் செலுத்தவும்',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Navigator.pushReplacementNamed(context, '/shopbills');
                          await commonController.getOrderDetails(id);
                          Get.toNamed('/shopbills');
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
                              'இப்போது செலுத்த',
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
              top: 5,
              right: 5,
              height: 30,
              width: 30,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/closeicon.png')),
            ),
          ],
        ),
      ),
    );
  }
}
