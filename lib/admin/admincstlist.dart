import 'package:billing_app/Models/stocklist_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCstList extends StatefulWidget {
  const AdminCstList({super.key});

  @override
  State<AdminCstList> createState() => _AdminCstListState();
}

/**/
class _AdminCstListState extends State<AdminCstList> {
  var commonController = Get.put(CommonController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        // appBar: AppBar(
        //   leading: GestureDetector(
        //     onTap: () {
        //       Navigator.pushReplacementNamed(context, '/billentries');
        //     },
        //     child: const Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       size: 18,
        //       color: Colors.white,
        //     ),
        //   ),
        //   title: const Text(
        //     'ஸ்டாக் பட்டியல்',
        //     style: TextStyle(color: Colors.white, fontSize: 15),
        //   ),
        //   backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        //   titleSpacing: -2.0,
        // ),
        body: Obx(() {
          return Column(
            children: [
              CustomAppBar(text: 'ஸ்டாக் பங்கு பட்டியல்', path: '/adminhome'),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          buildCard(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await commonController.getOrderDelivery(withLoader: true);
            await commonController.getShops(withLoader: true);
            await commonController.getStock();
            await commonController.getNoAccessUsers();
            Get.toNamed('/admincstlist2');
          },
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container buildCard(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'மொத்த ஸ்டாக்குகளின் பட்டியல்',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  if (commonController.stockList == false) ...[
                    const Text(
                      '',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ] else ...[
                    Text(
                      commonController.stockListModel.value!.data.date,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
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
          if (commonController.stockList == false) ...[
            const SizedBox(
              height: 50,
            ),
            const Text('வேறு தகவல்கள் இல்லை'),
            const SizedBox(
              height: 50,
            ),
          ] else ...[
            ListView.builder(
                itemCount: commonController
                    .stockListModel.value!.data.stockItem.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: ((context, index) {
                  return buildCardItem(commonController
                      .stockListModel.value!.data.stockItem[index]);
                })),
          ],
          // Container(
          //   child: Obx(
          //     () {
          //       final stocks =
          //           commonController.stockListModel.value!.data.stockItem;
          //       if (stocks == null || stocks.isEmpty) {
          //         return Text("No pending Order");
          //       }
          //       return ListView.builder(
          //           itemCount: stocks.length,
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           padding: EdgeInsets.all(0),
          //           itemBuilder: ((context, index) {
          //             return buildCardItem(stocks[index]);
          //           }));
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 5.0,
          ),
          const Divider(height: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SelectableText(
                  'மொத்தம்',
                  style: TextStyle(fontSize: 15),
                ),
                if (commonController.stockList == false) ...[
                  const SelectableText(
                    '₹  0',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ] else ...[
                  SelectableText(
                    '₹ ' + commonController.stockListModel.value!.data.amount.toString(),
                    style: const TextStyle(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCardItem(StockItem data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SelectableText(data.name)),
                Text(data.quantity + ' x ' + data.price),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('₹ ' + data.amount),
              ],
            ),
          )
        ],
      ),
    );
  }
}
