import 'package:billing_app/Models/shop_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Create_Individual_Bill extends StatefulWidget {
  const Create_Individual_Bill({super.key});

  @override
  State<Create_Individual_Bill> createState() => _Create_Individual_BillState();
}

class _Create_Individual_BillState extends State<Create_Individual_Bill> {
  List<String> list = <String>[];
  String dropdownValue = '';
  List<ShopData> shops = [];
  Map<int, bool> selectedShops = {};
  var commonController = Get.put(CommonController());
  bool iscreate = true;
  String shopError = '';
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    fetchPaths();
  }

  void fetchPaths() async {
    bool status = await commonController.getAllPath();
    if (status) {
      setState(() {
        list = commonController.pathmodel.value!.data
            .map((datum) => datum.name)
            .toList();
      });
    }
  }

  void fetchShops(String pathName) async {
    bool status = await commonController.getallShops();
    if (status) {
      setState(() {
        shops = commonController.shopsmodel.value!.data
            .where((shop) => shop.path == pathName)
            .toList();
        selectedShops = {for (var shop in shops) shop.storeId: false};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.toNamed('/individualbill');
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          body: Column(
            children: [
              CustomAppBar(
                text: 'தனிப்பட்ட ரசிது உருவாக்கவும்',
                path: '/individualbill',
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey, width: .5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value:
                                  dropdownValue.isEmpty ? null : dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  fetchShops(dropdownValue);
                                });
                              },
                              hint: const Text('பாதையை தேர்வு செய்க'),
                              style:
                                  const TextStyle(fontSize: 12, color: Colors.black),
                              icon: Image.asset(
                                'assets/images/arrowdown.png',
                                width: 13,
                              ),
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              underline: Container(),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            shopError,
                            style: const TextStyle(color: Colors.red, fontSize: 10.0),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('கடைகளைத் தேர்ந்தெடுக்கவும்'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(250, 250, 250, 1),
                              border: Border.all(
                                color: Colors.grey,
                                width: .5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                if (dropdownValue.isNotEmpty)
                                  ...shops
                                      .map((shop) => buildChoice(shop))
                                      .toList(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              createIndividualBill();
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 120,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(120, 89, 217, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: clicked
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'தனிப்பட்ட ரசிது உருவாக்க',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void createIndividualBill() async {
    List<int> selectedShopIds = selectedShops.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (dropdownValue.isEmpty) {
      setState(() {
        shopError = 'ஒரு பாதை மற்றும் குறைந்தது ஒரு கடையைத் தேர்ந்தெடுக்கவும்';
      });
      return;
    } else if (selectedShopIds.isEmpty) {
      setState(() {
        shopError = 'குறைந்தது ஒரு கடையைத் தேர்ந்தெடுக்கவும்';
      });
    } else {
      setState(() {
        shopError = '';
      });
      setState(() {
        clicked = true;
      });
      var selectedPath = commonController.pathmodel.value!.data
          .firstWhere((path) => path.name == dropdownValue);
      String pathid = selectedPath.pathId.toString();
      String shopid = selectedShopIds.join(',');

      Map map = {'path_id': pathid, 'stores_id': shopid};
      dynamic response = await CommonService().createIndBill(map);
      if (response['status'] == 1) {
        setState(() {
          iscreate = false;
        });
        showToast(response['message']);
        await commonController.getIndBill(withLoader: true);

        Get.toNamed('/individualbill');
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
        setState(() {
          clicked = false;
        });
      }
    }
  }

  Widget buildChoice(ShopData shop) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            activeColor: const Color.fromRGBO(120, 89, 207, 1),
            value: selectedShops[shop.storeId] ?? false,
            onChanged: (bool? value) {
              setState(() {
                selectedShops[shop.storeId] = value!;
              });
            },
          ),
          SelectableText('${shop.name} - ${shop.ownerName}'),
        ],
      ),
    );
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
}
