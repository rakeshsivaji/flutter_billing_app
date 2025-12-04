import 'package:billing_app/Models/shop_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/components/custom_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Create_Collection_Store extends StatefulWidget {
  const Create_Collection_Store({super.key});

  @override
  State<Create_Collection_Store> createState() =>
      _Create_Collection_StoreState();
}

class _Create_Collection_StoreState extends State<Create_Collection_Store> {
  List<String> list = <String>[];
  String dropdownValue = '';
  List<ShopData> shops = [];
  bool isselected = false;
  bool iscreate = false;
  Map<int, bool> selectedShops = {};
  var commonController = Get.put(CommonController());
  bool clicked = false;
  final _collectionPathNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPaths();
    fetchShops();
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

  void fetchShops() async {
    bool status = await commonController.getallShops();
    if (status) {
      setState(() {
        shops = commonController.shopsmodel.value!.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/savedroute');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'சேகரிப்பு பாதையை உருவாக்கவும்',
              path: '/savedroute',
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SelectableText('பாதையின் பெயரை உள்ளிடவும்'),
                          ),
                        ),
                        AppWidgetUtils.buildSizedBox(custHeight: 12),
                        CustomFormField(
                          hintText: 'பாதையின் பெயரை உள்ளிடவும்',
                            bgColor: AppColors().whiteColor,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide.none),
                            containerBorder: Border.all(
                              color: Colors.grey,
                            ),
                            controller: _collectionPathNameController),
                        AppWidgetUtils.buildSizedBox(custHeight: 4),
                        isselected
                            ? const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'சேகரிப்பு பாதை பெயரை உள்ளிடவும்',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 56, 49),
                                fontSize: 10),
                          ),
                        )
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value:
                                  dropdownValue.isEmpty ? null : dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              hint: const Text('சேகரிப்பு பாதையை தேர்வு செய்க'),
                              style:
                                  const TextStyle(fontSize: 12, color: Colors.black),
                              icon: const Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.black,
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
                        ),
                        (dropdownValue.isEmpty && isselected)
                            ? const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'ஒரு பாதையைத் தேர்ந்தெடுக்கவும்',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 141, 56, 49),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const SizedBox(height: 10),
                        (selectedShops.isEmpty && iscreate)
                            ? const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'ஒரு கடையைத் தேர்ந்தெடுக்கவும்',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 141, 56, 49),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
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
                                    .where((shop) => shop.path == dropdownValue)
                                    .map((shop) => buildChoice(shop))
                                    .toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            debugPrint('the clicked value is $clicked');
                            if (clicked == false) {
                              createSavedpath();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(120, 89, 207, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: clicked
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'உருவாக்க',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
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
    );
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

  void createSavedpath() async {
    List<int> selectedShopIds = selectedShops.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (dropdownValue.isEmpty) {
      setState(() {
        isselected = true;
        // iscreate = true;
      });
      // showToast("ஒரு பாதை மற்றும் குறைந்தது ஒரு கடையைத் தேர்ந்தெடுக்கவும்");
      return;
    }

    if (selectedShopIds.isEmpty) {
      setState(() {
        iscreate = true;
      });
      //showToast("ஒரு கடையைத் தேர்ந்தெடுக்கவும்");

      return;
    }

    if (_collectionPathNameController.text.isEmpty) {
      setState(() {
        iscreate = true;
      });
      return;
    }

    setState(() {
      clicked = true;
    });
    final selectedPath = commonController.pathmodel.value!.data
        .firstWhere((datum) => datum.name == dropdownValue);

    Map<String, dynamic> map = {
      ///hide the pathId
      /*'path_id': selectedPath.pathId,*/
      'stores_id': selectedShopIds.join(','),
      'path_name': _collectionPathNameController.text
    };

    dynamic response = await CommonService().createsavedpath(map);
    if (response['status'] == 1) {
      showToast(response['message']);
      commonController.getCollectionPath();
      Get.toNamed('/savedroute');
    } else {
      showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      setState(() {
        clicked = false;
      });
    }
  }
}
