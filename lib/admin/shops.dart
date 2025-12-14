import 'dart:async';

import 'package:billing_app/Models/shop_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Shops extends StatefulWidget {
  const Shops({super.key});

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  var commonController = Get.put(CommonController());
  final TextEditingController search = TextEditingController();
  String _selectedPathName = '';
  String _selectedShopName = '';
  final _pathStream = StreamController.broadcast();
  final _storeStream = StreamController.broadcast();
  final _storeListStream = StreamController.broadcast();
  Timer? _searchDebounce;

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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pathStream.add(true);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    search.dispose();
    _pathStream.close();
    _storeStream.close();
    _storeListStream.close();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    
    // First load paths if not already loaded
    if (commonController.pathmodel.value == null) {
      await commonController.getPath(withLoader: false);
    }
    
    // Auto-select first path to reduce initial data load
    if (commonController.pathmodel.value != null &&
        commonController.pathmodel.value!.data.isNotEmpty) {
      final firstPath = commonController.pathmodel.value!.data.first;
      _selectedPathName = firstPath.pathId.toString();
      
      // Always load shops filtered by first path only (much faster)
      // This ensures we only load shops for the first path, not all shops
      await Future.wait([
        commonController.getPathStore(_selectedPathName),
        commonController.getShops(
            withLoader: false, shopId: _selectedPathName),
      ]);
      
      _storeStream.add(true);
    } else {
      // Fallback: load all shops if no paths available
      if (commonController.shopsmodel.value == null ||
          commonController.shopsmodel.value!.data.isEmpty) {
        await commonController.getShops(withLoader: false);
      }
    }
    
    setState(() {
      _isLoading = false;
    });
    _storeListStream.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'கடைகள்',
              path: '/adminhome',
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromRGBO(250, 250, 250, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: search,
                            onChanged: (value) {
                              // Debounce search to avoid too many API calls
                              _searchDebounce?.cancel();
                              _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                                filterJobs(search: value);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'தேடு கடை',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/images/search.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildShopNameAndPathNameFilterDropdown(),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                            stream: _storeListStream.stream,
                            builder: (context, snapshot) {
                              if (_isLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return Container(
                                child: Obx(() {
                                  final shops =
                                      commonController.shopsmodel.value?.data;
                                  if (shops == null) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (shops.isEmpty) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Text('கடைகள் இல்லை'),
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: shops.length ?? 0,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: ((context, index) {
                                      return buildCard(shops[index]);
                                    }),
                                  );
                                }),
                              );
                            }),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await [
              commonController.getPath(withLoader: true),
              commonController.getallProduct(withLoader: true),
              commonController.getOrderDelivery(withLoader: true)
            ];
            Get.toNamed('/createshop');
            // Navigator.pushReplacementNamed(context, '/createshop');
          },
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  filterJobs({
    String? search,
  }) async {
    if (search == null || search.isEmpty) {
      // If search is empty, reload all shops
      setState(() {
        _isLoading = true;
      });
      await commonController.getShops(
        withLoader: false,
        search: null,
      );
      setState(() {
        _isLoading = false;
      });
      _storeListStream.add(true);
    } else {
      // Filter with search
      setState(() {
        _isLoading = true;
      });
      await commonController.getShops(
        withLoader: false,
        search: search,
      );
      setState(() {
        _isLoading = false;
      });
      _storeListStream.add(true);
    }
  }

  Container buildCard(ShopData data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(120, 89, 207, 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(19, 19, 19, 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/shopicon.png',
                  width: 18,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        data.path ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectableText(
                        data.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        data.address,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () async {
                    Get.toNamed('/editshop', arguments: {'id': data.storeId});
                    await commonController.getPath(withLoader: true);
                    await commonController.getOrderDelivery(
                        withLoader: true, storeid: data.storeId.toString());
                    print(data.storeId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.asset(
                      'assets/images/edit.png',
                      width: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () {
                    _PopupMenu(data.storeId.toString());
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 60.0, top: 15.0, bottom: 15.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(data.ownerName)),
                const SizedBox(
                  width: 10.0,
                ),
                SelectableText(data.phone),
              ],
            ),
          )
        ],
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
                    'கடையை நிச்சயமாக நீக்க விரும்புகிறீர்களா?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
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
                        onTap: () {
                          delete(context, id);
                          Navigator.pop(context);
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
                              'அழி',
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

  void delete(BuildContext context, String id) async {
    dynamic response = await CommonService().deleteShop(id);
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        setState(() {
          _isLoading = true;
        });
        await commonController.getShops(withLoader: false);
        setState(() {
          _isLoading = false;
        });
        _storeListStream.add(true);
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: _pathStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _selectedPathName,
                'பாதையைத் தேர்ந்தெடுக்கவும்',
                commonController.pathmodel.value?.data.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.pathId.toString(),
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _selectedPathName = onChangeValue.toString();
                  _selectedShopName = '';
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.wait([
                    commonController.getPathStore(_selectedPathName),
                    commonController.getShops(
                        withLoader: false, shopId: _selectedPathName),
                  ]);
                  setState(() {
                    _isLoading = false;
                  });
                  _storeListStream.add(true);
                  _storeStream.add(true);
                },
              );
            }),
        const SizedBox(height: 15,),
        StreamBuilder(
            stream: _storeStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _selectedShopName,
                'தேர்வு கடை',
                commonController.pathStoreModel.value?.data.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.id.toString(),
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _selectedShopName = onChangeValue.toString();
                  setState(() {
                    _isLoading = true;
                  });
                  await commonController.getShops(
                      withLoader: false,
                      shopId: _selectedPathName,
                      pathId: _selectedShopName);
                  setState(() {
                    _isLoading = false;
                  });
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
      width: MediaQuery.sizeOf(context).width,
      // width: MediaQuery.sizeOf(context).width / 2.4,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }
}
