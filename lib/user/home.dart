import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var commonController = Get.put(CommonController());

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  getNotification() async {
    await commonController.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(animated: false);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 50.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                          image: DecorationImage(
                              image: NetworkImage(commonController
                                      .adminprofilemodel.value?.data.image ??
                                  ''),
                              fit: BoxFit.cover),
                        ),
                        //child: Image.network(commonController.adminprofilemodel.value!.data.image),
                        //child: Image.asset('assets/images/profile.png'),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SelectableText(
                      commonController.adminprofilemodel.value?.data.name ??
                          'User',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // Navigator.pushReplacementNamed(
                              //     context, '/announce');
                              await commonController.getNotification();
                              await commonController.getPath(withLoader: true);
                              await commonController.getPathClosed();
                              await commonController.getUserIndividualBills();
                              await commonController.getPathBillEntries('1');
                              await commonController.getUserProfile();
                              Get.toNamed('/billentries',
                                  arguments: {'isNotification': true});
                            },
                            child: (commonController.notification == true)
                                ? Image.asset(
                                    'assets/images/notification.png',
                                    width: 25,
                                  )
                                : const Icon(
                                    Icons.notifications,
                                    color: Color.fromRGBO(120, 89, 207, 1),
                                    size: 30,
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await commonController.getOrderDelivery(
                            withLoader: true);
                        await commonController.getPath(withLoader: true);
                        Get.toNamed('/orderscreen');
                      },
                      child: buildoptions(context, 'assets/images/order.png',
                          'ஆர்டர் டெலிவரி', '/orderscreen'),
                    ),
                    commonController
                                .adminprofilemodel.value?.data.collectionPath ==
                            'null'
                        ? const SizedBox()
                        : InkWell(
                            //
                            onTap: () async {
                              // await commonController.getAllBillEntries();
                              /*await commonController.getPath(withLoader: true);
                              await commonController.getPathClosed();
                              await commonController.getUserIndividualBills();*/
                              await commonController.getPathBillEntries('1');
                              await commonController.getUserProfile();
                              Get.toNamed('/billentries',
                                  arguments: {'isNotification': false});
                            },
                            child: buildoptions(
                                context,
                                'assets/images/bill3.png',
                                'ரசீது உள்ளீடுகள்',
                                '/billentries'),
                          ),

                    ///This below code is Stock patiyal menu code...
                    /*InkWell(
                      onTap: () async {
                        await commonController.getAdminStockList();
                        await commonController.getAdminStockListShow(
                            withLoader: true);
                        Get.toNamed('/stocklist');
                      },
                      child: buildoptions(context, 'assets/images/stock.png',
                          'ஸ்டாக் பட்டியல்', '/stocklist'),
                    ),*/
                    /*(commonController.adminprofilemodel.value?.data
                                    .collectionPathName !=
                                null ||
                            commonController.adminprofilemodel.value?.data
                                    .collectionPath !=
                                'null')
                        ? const SizedBox.shrink()
                        : */
                    InkWell(
                      onTap: () async {
                        await commonController.getuserline();
                        Get.toNamed('/stockline');
                      },
                      child: buildoptions(
                        context,
                        'assets/images/stocklist.png',
                        'ஸ்டாக்',
                        '/stockline',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildoptions(
      BuildContext context, String imagepath, String name, String path) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Image.asset(
                imagepath,
                fit: BoxFit.fitHeight,
              )),
          const SizedBox(
            height: 15,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(120, 89, 207, 1)),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
