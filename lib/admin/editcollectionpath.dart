import 'dart:async';

import 'package:billing_app/Models/allcollectionpath_model.dart';
import 'package:billing_app/Models/edit_collection_path_model.dart';
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

class Editcollectionpath extends StatefulWidget {
  const Editcollectionpath({super.key});

  @override
  State<Editcollectionpath> createState() => _EditcollectionpathState();
}

class _EditcollectionpathState extends State<Editcollectionpath> {
  List<String> list = <String>[];
  String dropdownValue = '';
  List<Datum> shops = [];
  bool isselected = false;
  bool iscreate = false;
  Map<int, bool> selectedShops = {};
  List<bool> isChecked = [];
  List<String> selectedStore = [];
  String pathId = '';
  var commonController = Get.put(CommonController());
  EditCollectionPathModel? editCollectionPathModel;
  bool clicked = false;
  String? _orderStoreIds;
  String? _finalIds;
  List<String> paths = [];
  List<ShopData> shopDatas = [];
  final _collectionPathNameController = TextEditingController();
  final _storeListStream = StreamController.broadcast();

  List<Store>? getStoreData;

  @override
  void initState() {
    super.initState();
    pathId = Get.arguments['id'].toString();
    fetchPaths();
    fetchShops();
    getStoreData = commonController.editCollectionPathModel.value?.data.store;
    _orderStoreIds = getStoreData
        ?.map(
          (e) => e.id,
        )
        .join(',');
    getData();
  }

  void fetchPaths() async {
    bool status = await commonController.getAllPath();
    if (status) {
      setState(() {
        paths = commonController.pathmodel.value!.data
            .map((datum) => datum.name)
            .toList();
      });
    }
  }

  void fetchShops() async {
    bool status = await commonController.getallShops();
    if (status) {
      setState(() {
        shopDatas = commonController.shopsmodel.value!.data;
      });
    }
  }

  void getData() async {
    print(commonController.editCollectionPathModel.value!.data.pathName
        .toString());
    _collectionPathNameController.text =
        commonController.editCollectionPathModel.value?.data.pathName ?? '';
    print('hi');
    for (var stores in getStoreData!) {
      int id = stores.id;
      bool status = stores.status;
      if (status) {
        setState(() {
          selectedStore.add(id.toString());
        });
      }
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
                        AppWidgetUtils.buildSizedBox(custHeight: 18),
                        CustomFormField(
                            bgColor: AppColors().whiteColor,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide.none),
                            containerBorder: Border.all(
                              color: Colors.grey,
                            ),
                            controller: _collectionPathNameController),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SelectableText('கடைகளைத் தேர்ந்தெடுக்கவும்'),
                          ),
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
                        _buildShopPathsDropDown(),
                        _buildSelectingTheShops(),
                        const SizedBox(
                          height: 18,
                        ),
                        StreamBuilder(
                            stream: _storeListStream.stream,
                            builder: (context, snapshot) {
                              return Container(
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
                                    Container(
                                      child: ReorderableListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        onReorder: (oldIndex, newIndex) {
                                          if (newIndex > oldIndex) {
                                            newIndex -= 1;
                                          }
                                          final item =
                                              getStoreData?.removeAt(oldIndex);
                                          getStoreData?.insert(newIndex, item!);
                                          final status =
                                              isChecked.removeAt(oldIndex);
                                          isChecked.insert(newIndex, status);
                                          setState(() {
                                            _orderStoreIds = getStoreData
                                                ?.map(
                                                  (e) => e.id,
                                                )
                                                .join(',');
                                          });
                                        },
                                        children: List.generate(
                                          getStoreData?.length ?? 0,
                                          (index) {
                                            isChecked.add(
                                              getStoreData?[index].status ??
                                                  false,
                                            );
                                            return buildChoice(
                                              index,
                                              getStoreData?[index],
                                            );
                                          },
                                        ).map((widget) {
                                          return KeyedSubtree(
                                            key: ValueKey(widget),
                                            child: widget,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            if (clicked == false) {
                              updateSavedpath();
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

  Widget buildChoice(int index, Store? data) {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                selectedStore.remove(data?.id.toString());
                getStoreData?.remove(data);
                debugPrint('the getstore dtaa is **** ${getStoreData?.map(
                  (e) => e.name,
                )}');
                _storeListStream.add(true);
              },
              icon: const Icon(Icons.close)),

          //This Check box is old feature
          /*Checkbox(
            activeColor: Color.fromRGBO(120, 89, 207, 1),
            value: isChecked[index],
            onChanged: (bool? value) {
              setState(() {
                isChecked[index] = value!;
                isChecked[index]
                    ? selectedStore.add(data?.id.toString() ?? '')
                    : selectedStore.remove(data?.id.toString());
                print(selectedStore);
              });
            },
          ),*/

          SelectableText('${data?.name}'),
          const Spacer(),
          ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle), // Drag handle icon
          ),
          const SizedBox(
            width: 12,
          )
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

  void updateSavedpath() async {
    _finalIds = getStoreData
        ?.map(
          (e) => e.id,
        )
        .join(',');

    /*if (_finalIds?.isEmpty == true || _finalIds == null) {
      showToast('குறைந்தது ஒரு கடையைத் தேர்ந்தெடுக்கவும்');
    } else {*/
      setState(() {
        clicked = true;
      });
      dynamic response = await CommonService().updateSavedPath(
          pathId, _finalIds ?? '',
          orderStoreIds: _finalIds, pathName: _collectionPathNameController.text);
      if (response['status'] == 1) {
        showToast(response['message']);
        await commonController.getCollectionPath();
        Get.toNamed('/savedroute');
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
        setState(() {
          clicked = false;
        });
      }
    // }
  }

  Widget _buildShopPathsDropDown() {
    return Padding(
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
          value: dropdownValue.isEmpty ? null : dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          hint: const Text('சேகரிப்பு பாதையை தேர்வு செய்க'),
          style: const TextStyle(fontSize: 12, color: Colors.black),
          icon: const Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.black,
          ),
          items: paths.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: Container(),
        ),
      ),
    );
  }

  Widget _buildSelectingTheShops() {
    return Container(
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
            ...shopDatas
                .asMap()
                .entries
                .where((entry) => entry.value.path == dropdownValue)
                .map((entry) {
              int index = entry.key;
              var shop = entry.value;
              var store = (index >= 0 && index < (getStoreData?.length ?? 0))
                  ? getStoreData![index]
                  : null;

              return _buildSelectShopChoice(index, shop, store);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildSelectShopChoice(
    int index,
    ShopData shop,
    Store? store,
  ) {
    bool isCheckedForShop = false;

    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  /*bool alreadySelected = false;

                  for (var i in selectedStore) {
                    if (i == shop.storeId.toString()) {
                      showToast('இந்த கடை ஏற்கனவே தேர்ந்தெடுக்கப்பட்டது');
                      alreadySelected = true;
                      break;
                    }
                  }*/

                  bool? isMatching = getStoreData?.any(
                    (element) => element.id == shop.storeId,
                  );
                  if (isMatching == true) {
                    showToast('இந்த கடை ஏற்கனவே தேர்ந்தெடுக்கப்பட்டது');
                  } else {
                    final recentlyAddedStore = convertShopToStore(shop);
                    getStoreData?.add(recentlyAddedStore);
                    _storeListStream.add(true);
                  }

                  /*if (!alreadySelected) {
                    final recentlyAddedStore = convertShopToStore(shop);
                    */ /*selectedStore.add(store?.id.toString() ?? '');*/ /*
                    getStoreData?.add(recentlyAddedStore);
                    _storeListStream.add(true);

                    debugPrint(
                        'Recently added store: ${recentlyAddedStore.name} - ${recentlyAddedStore.toJson()}');
                    debugPrint('Store ID: ${recentlyAddedStore.id}');
                  }*/
                });
              },
              icon: const Icon(Icons.add)),
          SelectableText('${shop.name} - ${shop.ownerName}'),
        ],
      ),
    );
  }

  Store convertShopToStore(ShopData shop) {
    return Store(
      id: shop.storeId,
      name: shop.name,
      status: true,
    );
  }
}
