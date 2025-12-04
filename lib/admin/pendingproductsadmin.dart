import 'package:billing_app/Models/shop_pending_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingProductsAdmin extends StatefulWidget {
  const PendingProductsAdmin({super.key});

  @override
  State<PendingProductsAdmin> createState() => _PendingProductsAdminState();
}

class _PendingProductsAdminState extends State<PendingProductsAdmin> {
  var commonController = Get.put(CommonController());
  //String lineid = '';
  List<bool> pending = [];
  // @override
  // void initState() {
  //   super.initState();
  //   lineid = (Get.arguments?['id']) ?? '';
  //   print(lineid);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await commonController.getuserlinereport(lineid.toString());
        // Get.toNamed('/stocklinereport');
        Get.back();
        return false;
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
                padding: const EdgeInsets.fromLTRB(
                  20.0,
                  0.0,
                  20.0,
                  20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                Get.back();
                                // await commonController
                                //     .getuserlinereport(lineid.toString());
                                // Get.toNamed('/stocklinereport');
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
                          width: 20.0,
                        ),
                        const Expanded(
                          child: Text(
                            'நிலுவையில் உள்ள பொருட்கள்',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
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
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (commonController.shopPendingModel.value?.data ==
                              null ||
                          commonController
                              .shopPendingModel.value!.data.isEmpty) ...[
                        const Text('ஆர்டர்கள் பட்டியல் இல்லை'),
                      ] else ...[
                        ListView.builder(
                          itemCount: commonController
                                  .shopPendingModel.value?.data.length ??
                              0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            pending.add(false);
                            return buildCard(
                                index,
                                commonController
                                    .shopPendingModel.value!.data[index]);
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(int index, ShopPendingDataModel data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
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
                  const SelectableText(
                    '',
                    //data.orderId.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    data.date.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: SelectableText(
                  data.pathName.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: SelectableText(
                  data.storeName,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: SelectableText(
                  data.storeAddress,
                  style: const TextStyle(fontSize: 13),
                ),
              )),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      pending[index] = !pending[index];
                    });
                  },
                  child: const Text(
                    'விபரங்களை பார்க்க',
                    style: TextStyle(
                        fontSize: 11, color: Color.fromRGBO(120, 89, 207, 1)),
                  ),
                ),
              ],
            ),
          ),
          pending[index]
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ஆர்டர் விவரங்கள்',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ListView.builder(
                      itemCount: data.pendingQuantity.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return buildItems(data.pendingQuantity[index]);
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    )
                  ],
                )
              : const SizedBox(
                  height: 10.0,
                ),
        ],
      ),
    );
  }

  Padding buildItems(PendingQuantity data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 8, child: SelectableText(data.name)),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText('x ' + data.quantity.toString(),
                      style: const TextStyle(fontSize: 15)),
                ],
              )),
        ],
      ),
    );
  }
}
