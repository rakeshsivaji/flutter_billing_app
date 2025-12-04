import 'package:billing_app/Models/pending_lines_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingProductLines extends StatefulWidget {
  const PendingProductLines({super.key});

  @override
  State<PendingProductLines> createState() => _PendingProductLinesState();
}

class _PendingProductLinesState extends State<PendingProductLines> {
  var commonController = Get.put(CommonController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/stocklinereport');
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
                                // await commonController
                                //     .getuserlinereport(lineid.toString());
                                Get.toNamed('/stocklinereport');
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
                      if (commonController.pendingLinesModel.value?.data ==
                              null ||
                          commonController
                              .pendingLinesModel.value!.data.isEmpty) ...[
                        const Text('நிலுவையில் உள்ள பொருட்கள் இல்லை'),
                      ] else ...[
                        ListView.builder(
                          itemCount: commonController
                                  .pendingLinesModel.value?.data.length ??
                              0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return buildCard(commonController
                                .pendingLinesModel.value!.data[index]);
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

  Widget buildCard(Datum data) {
    return GestureDetector(
      onTap: () async {
        await commonController.getshopPendingreport(data.lineId.toString());
        Get.toNamed('pendingproductsadmin');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(15),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SelectableText(
                      'நிலுவையில் உள்ள பொருட்கள்',
                      //data.orderId.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                    SelectableText(
                      data.lineName,
                      //data.date.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
                ListView.builder(
                  itemCount: data.products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return buildItems(data.products[index]);
                  },
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
                        data.totalPendingQuantity.toString(),
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
      ),
    );
  }

  Padding buildItems(Product data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 8, child: Text(data.productName)),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('x ' + data.pendingQuantity.toString(),
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
}
