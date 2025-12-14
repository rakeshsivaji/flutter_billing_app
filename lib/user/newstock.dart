import 'package:billing_app/Models/userlinereport_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class New_Stock extends StatefulWidget {
  const New_Stock({super.key});

  @override
  State<New_Stock> createState() => _New_StockState();
}

class _New_StockState extends State<New_Stock> {
  var commonController = Get.put(CommonController());

  // List<bool> expand = [];
  bool completed = true;
  bool isexpand = false;
  bool? status;
  String lineid = '';

  @override
  void initState() {
    super.initState();
    status = (Get.arguments?['status']) ?? true;
    lineid = (Get.arguments?['id']) ?? '';
    print(lineid);
  }

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
    commonController.getuserlinereport(
        commonController.userlinemodel.value?.data.first.lineId.toString() ??
            '');

    print('Value');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await commonController.getuserline();
        Get.toNamed('/stockline');
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
                onTap: () async {
                  await commonController.getuserline();
                  Get.toNamed('/stockline');
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: const Text(
              'ஸ்டாக்',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
            titleSpacing: -2.0,
          ),
          body: Obx(
            () {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            if (status == true) ...[
                              InkWell(
                                onTap: () async {
                                  await commonController
                                      .getStockListline(lineid);
                                  await commonController.getUserProfile();
                                  Get.toNamed('/cstlist',
                                      arguments: {'id': lineid});
                                },
                                child: imageContainer(
                                    'assets/images/stockorder.png', 'ஸ்டாக்ஸ்'),
                              ),
                              InkWell(
                                onTap: () async {
                                  await commonController.getOrderDelivery(
                                      withLoader: true);
                                  await commonController.getPath(
                                      withLoader: true);
                                  Get.toNamed('/neworderscreen',
                                      arguments: {'id': lineid});
                                },
                                child: imageContainer(
                                    'assets/images/stockbill.png', 'ரசீதுகள்'),
                              ),
                            ],
                            const SizedBox(
                              height: 40,
                            ),
                            if (commonController.userlinereport == true) ...[
                              commonbuild(),
                              buildCard(commonController
                                  .userlinereportmodel.value!.data.pending)
                            ],
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await commonController.getshopPendingreport(
                                  lineid,
                                  callBackFunction: (statusCode) async {
                                    if (statusCode == 1) {
                                      await commonController.getPath(
                                          withLoader: true);
                                      Get.toNamed('pendingproducts',
                                          arguments: {
                                            'id': lineid,
                                            'statusCode': statusCode
                                          });
                                    } else {
                                      await commonController.getPath(
                                          withLoader: true);
                                      Get.toNamed('pendingproducts',
                                          arguments: {
                                            'id': lineid,
                                            'statusCode': statusCode
                                          });
                                    }
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                height: 50,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(120, 89, 207, 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    'நிலுவையில் உள்ள பொருட்கள்',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _PopupMenu1(lineid);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      height: 50,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            120, 89, 207, 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: status == true
                                          ? Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(Icons
                                                          .pause_circle_outline_outlined),
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Expanded(
                                                    flex: 5,
                                                    child: Text(
                                                      'முடிக்கப்பட்ட',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                child: const Center(
                                                  child: Text(
                                                    'முடிக்கப்பட்டது',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Container commonbuild() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(120, 89, 217, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    commonController
                        .userlinereportmodel.value!.data.delivery.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    commonController
                        .userlinereportmodel.value!.data.delivery.date,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0.5,
          ),
          const SizedBox(
            height: 10.0,
          ),
          !isexpand
              ? Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'மொத்த ஸ்டாக்குகளின் எண்ணிக்கை',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'மீதமுள்ள ஸ்டாக்குகளின் எண்ணிக்கை',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          commonController.userlinereportmodel.value!.data
                              .delivery.totalStock
                              .toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          commonController.userlinereportmodel.value!.data
                              .delivery.pendingStock
                              .toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              'ஸ்டாக்கள்',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              'மொத்த ஸ்டாக்களின் எண்ணிக்கை',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              'மீதமுள்ள ஸ்டாக்களின் எண்ணிக்கை',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: Obx(() {
                          final userreport = commonController
                              .userlinereportmodel.value!.data.delivery.products;
                          return ListView.builder(
                            itemCount: userreport.length,
                            padding: const EdgeInsets.all(0),
                            itemBuilder: ((context, index) {
                              return linebuild1(userreport[index]);
                            }),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              'Total',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              commonController.userlinereportmodel.value!.data
                                  .delivery.totalStock
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              commonController.userlinereportmodel.value!.data
                                  .delivery.pendingStock
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                    ],
                  ),
                ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'சேகரிக்கப்பட்ட தொகை',
                style: TextStyle(fontSize: 13),
              ),
              Text(
                '₹ ' +
                    (commonController.userlinereportmodel.value!.data.delivery
                            .collectionAmount
                            .toString() ??
                        ''),
                style: const TextStyle(fontSize: 13),
              ),

              ///motham thogai and metham ulla thogai.
              /*const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'மொத்த தொகை',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'மீதமுள்ள தொகை',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    'மீதமுள்ள தொகை',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ ' +
                        commonController.userlinereportmodel.value!.data
                            .delivery.totalAmount
                            .toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '₹ ' +
                        commonController.userlinereportmodel.value!.data
                            .delivery.pendingAmount
                            .toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),*/
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  setState(() {
                    // expand[0] = !expand[0];
                    isexpand = !isexpand;
                  });
                },
                child: !isexpand
                    ? const Text(
                        'விபரங்களை பார்க்க',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(120, 89, 207, 1)),
                      )
                    : const Text(
                        'குறைவாக காட்டு',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(120, 89, 207, 1)),
                      )),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Container linebuild1(Product produt) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  produt.name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  produt.totalQuantity.toString(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  produt.pendingQuantity.toString(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
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
                      'இந்த வழியை நீங்கள் நிறுத்த வேண்டுமா ?',
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
                          submit();
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

  Center imageContainer(String imagepath, String label) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    'assets/images/stockbg.png'),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        imagepath,
                        height: 70,
                      ),
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color.fromRGBO(120, 89, 207, 1),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Pending? data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(120, 89, 217, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    'நிலுவையில் உள்ள பொருட்கள்',
                    //data.orderId.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    '',
                    //data.date.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              if (data?.totalProductPending.isEmpty == true) ...[
                const SizedBox(
                  height: 30,
                ),
                const Text('நிலுவை பொருட்கள் இல்லை'),
                const SizedBox(
                  height: 30,
                ),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: ListView.builder(
                  itemCount: data?.totalProductPending.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return buildItems(data?.totalProductPending[index]);
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Divider(),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'மொத்த எண்ணிக்கை',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      data?.totalPending.toString() ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding buildItems(TotalProductPending? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 8, child: Text(data?.productName ?? '')),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('x ' + (data?.totalPendingQuantity.toString() ?? ''),
                    style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
          // Container(
          //   width: 80,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Text('x ' + data.productAmount.toString(),
          //           style: TextStyle(fontSize: 15)),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void submit() async {
    print(lineid);
    dynamic response = await CommonService().linecompleted(lineid);
    if (response['status'] == 1) {
      showToast(response['message']);
      await commonController.getuserline();
      Get.toNamed('/stockline');
    } else {
      showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
    }
  }
}
