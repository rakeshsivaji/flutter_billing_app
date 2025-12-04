import 'dart:async';

import 'package:billing_app/Models/get_user_paths.dart';
import 'package:billing_app/Models/get_user_shop_list.dart';
import 'package:billing_app/Models/path_billentry_model.dart';
import 'package:billing_app/Models/path_closed_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/app_service.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

class Billentries extends StatefulWidget {
  const Billentries({super.key});

  @override
  State<Billentries> createState() => _BillentriesState();
}

class _BillentriesState extends State<Billentries> {
  var commonController = Get.put(CommonController());
  String pathcloseid = '';
  bool rootclosed = true;
  int? id;
  List<String> list = <String>[
    // 'Tirunelveli - Tenkasi',
    // 'Tenkasi - Tirunelveli'
  ];
  String dropdownValue = '';
  String extravalue = '';
  String _selectedShopName = '';
  String _selectedPathId = '';
  StreamController _storeStream = StreamController.broadcast();
  StreamController _pathStream = StreamController.broadcast();
  StreamController _storeListStream = StreamController.broadcast();
  List<ShopData>? _shopListData;
  List<PathData>? _pathListData;

  bool _isVisible = false;
  bool _isNotification = false;
  List<BillPathEntryData> allBillEntry = [];

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
    await commonController.getPath(withLoader: true);
    await commonController.getPathClosed();
    await commonController.getUserIndividualBills();
    await commonController.getPathBillEntries('1');
    print('Value');
  }

  @override
  void initState() {
    super.initState();
    _isNotification = Get.arguments?['isNotification'] == null
        ? false
        : Get.arguments?['isNotification'];
    _fetchUserPaths();
  }

  Future<void> _fetchUserPaths() async {
    await AppServiceUtilsImpl().getUserPaths(
      callBack: (response) {
        if (response.status == 1) {
          _pathListData = response.data;
          _pathStream.add(true);
        } else {
          _pathListData = [];
          _pathStream.add(true);
        }
      },
    );
  }

  Future<void> _fetchStoreList() async {
    await AppServiceUtilsImpl().getUserShopList(
      pathId: _selectedPathId,
      callBack: (response) {
        if (response.status == 1) {
          _shopListData = response.data;
          _storeStream.add(true);
        } else {
          _shopListData = [];
          _storeStream.add(true);
        }
      },
    );
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
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(120, 89, 207, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
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
                                    onTap: () {
                                      Navigator.popAndPushNamed(
                                          context, '/home');
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
                              Expanded(
                                child: Text(
                                  _isNotification
                                      ? 'அறிவிப்பு'
                                      : 'ரசீது உள்ளீடுகள்',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              _isNotification
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () async {
                                        await commonController
                                            .getAllBillEntries();
                                        await commonController
                                            .getAllBillStores();
                                        await commonController.getPath(
                                            withLoader: true);
                                        await commonController
                                            .getAllUserBillEntries();
                                        Get.toNamed('/enteredbills');
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: const Center(
                                            child: Text(
                                          'ரசீதுகளை உள்ளிட்டது',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  120, 89, 207, 1),
                                              fontSize: 10),
                                        )),
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
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                /*Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue.isEmpty
                                        ? null
                                        : dropdownValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        _isVisible = true;
                                        rootclosed = true;
                                      });
                                      commonController.getPathBillEntries(
                                          commonController.pathId![dropdownValue]
                                              .toString());
                                    },
                                    hint: Text('பாதையைத் தேர்ந்தெடுக்கவும்'),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    icon: Image.asset(
                                      'assets/images/arrowdown.png',
                                      width: 15,
                                    ),
                                    items: commonController.pathName!
                                        .map((id, name) {
                                          return MapEntry(
                                              id,
                                              DropdownMenuItem<String>(
                                                value: name,
                                                child: Text(name),
                                              ));
                                        })
                                        .values
                                        .toList(),
                                    underline: Container(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),*/
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'மூடப்பட்ட பாதைகள்',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: Color.fromRGBO(120, 89, 207, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),*/
                                // if(commonController.pathclosedmodel.value?.pathData==null)...[
                                //  Text('மூடப்பட்ட பாதைகள் இல்லை'),

                                // ]
                                /*Container(
                                  child: Obx(() {
                                    final pathclosed = commonController
                                        .pathclosedmodel.value?.pathData;
                                    if (pathclosed == null ||
                                        pathclosed.isEmpty) {
                                      return SelectableText(
                                          'மூடப்பட்ட பாதைகள் இல்லை.');
                                    }
                                    return ListView.builder(
                                      itemCount: pathclosed.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      itemBuilder: ((context, index) {
                                        return pathBuild(pathclosed[index]);
                                      }),
                                    );
                                  }),
                                ),*/
                              ],
                            ),
                          ),
                          /*const SizedBox(
                            height: 20,
                          ),*/
                          /*if (_isVisible)*/ Expanded(child: containBuild()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Column(
      children: [
        StreamBuilder(
            stream: _pathStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _selectedPathId,
                'பாதையைத் தேர்ந்தெடுக்கவும்',
                _pathListData?.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.id.toString(),
                        child: Text(
                          item.name ?? '',
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _selectedPathId = onChangeValue.toString();
                  _selectedShopName = '';
                  await _fetchStoreList();
                  await commonController.getPathBillEntries('1',
                      storeId: _selectedShopName, pathId: _selectedPathId);
                  _storeListStream.add(true);
                },
              );
            }),
        AppWidgetUtils.buildSizedBox(
            custHeight: MediaQuery.sizeOf(context).width * 0.03),
        StreamBuilder(
            stream: _storeStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _selectedShopName,
                'தேர்வு கடை',
                _shopListData?.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.id.toString(),
                        child: Text(
                          item.name ?? '',
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _selectedShopName = onChangeValue.toString();
                  await commonController.getPathBillEntries('1',
                      storeId: _selectedShopName, pathId: _selectedPathId);
                  _storeListStream.add(true);
                },
              );
            }),
      ],
    );
  }

  Widget _buildShopNameDropdown(
    String dropDownValue,
    String hintText,
    List<DropdownMenuItem<String?>> menuItems,
    Function(String?)? onChange,
  ) {
    return CustomDropDownButtonFormField(
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)
      ],
      fillColor: Colors.white,
      inputBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      // width: MediaQuery.sizeOf(context).width * 0.5,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }

  Widget containBuild() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(120, 89, 207, 0.05),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'சேகரிப்பு பாதை பெயர்: ${commonController.adminprofilemodel.value?.data.collectionPathName ?? ''}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            _buildShopNameAndPathNameFilterDropdown(),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Obx(() {
                final allbillentry =
                    commonController.pathbillentrymodel.value?.data ?? [];
                if (allbillentry.isEmpty) {
                  return const SelectableText('ரசீதுகள் எதுவும் இல்லை.');
                }
                return ListView.builder(
                  itemCount: allbillentry.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: ((context, index) {
                    return buildCards(allbillentry[index], index);
                  }),
                );
              }),
            ),

            ///Valiyai moodu button
            /*SizedBox(
              height: 50,
            ),
            rootclosed
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {
                        bool hasNotBillEntered = commonController
                                .pathbillentrymodel.value?.data
                                .any((e) => e.status == 'Bill Not Enterd') ??
                            false;
                        // await commonController
                        //     .getAllBillEntries(data.categoryId.toString());
                        // Get.toNamed('/billentries',
                        //     arguments: {"id": data.categoryId.toString()});
                        // setState(() {
                        //   pathcloseid =
                        //       commonController.pathId![dropdownValue].toString();
                        // });
                        // submit(pathcloseid);
                        // print(commonController.pathId![dropdownValue].toString());
                        if (dropdownValue.isEmpty) {
                          showToast('பாதையைத் தேர்ந்தெடுக்கவும்');
                        }else if(hasNotBillEntered){
                          showToast('அனைத்து ரசீதுகளும் செலுத்தப்படவில்லை');
                        } else {
                          submit();
                          // print('success');
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromRGBO(120, 89, 207, 1),
                        ),
                        child: Center(
                          child: Text(
                            'வழியை மூடு',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  )
                : SelectableText(''),*/
          ],
        ),
      ),
    );
  }

  Padding pathBuild(PathDatum data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/route.png',
            width: 22,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: SelectableText(
            data.pathName,
            // 'திருநெல்வேலி - புளியங்குடி வழி மூடப்பட்டுள்ளது,',
            style: const TextStyle(fontSize: 17),
          )),
          InkWell(
            onTap: () async {
              setState(() {
                _isVisible = !_isVisible;
                rootclosed = false;
                pathcloseid = data.pathId.toString();
                print(pathcloseid);
              });
              await commonController.getPathBillEntries(data.pathId);
            },
            child: Image.asset(
              'assets/images/arrowgreen.png',
              width: 20,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildCards(BillPathEntryData data, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          id = data.orderId;
        });
        if (data.status != 'Bill Enterd') {
          _PopupMenu();
        }
      } /*: (){
        showToast('ரசீதுகளை வரிசையாக உள்ளிடவும்');
      }*/
      ,
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
                        data.storeName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SelectableText(
                        data.pathName,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SelectableText(
                        data.storeAddress,
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
                        data.ownerName,
                        style: const TextStyle(fontSize: 13),
                      ),
                      SelectableText(
                        data.ownerPhone,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
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
                    data.status,
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

  void _PopupMenu() {
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
                          await commonController.getOrderDetails(id.toString());
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

  void submit() async {
    try {
      dynamic response = await CommonService()
          .PostPathClosed(commonController.pathId![dropdownValue].toString());

      if (response['status'] == 1) {
        showToast(response['data']);
        await commonController.getPathClosed();
        Get.toNamed('/billentries');
        setState(() {
          _isVisible = false;
        });
      } else {
        showToast(response['data'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }
}
