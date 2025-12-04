import 'dart:async';

import 'package:billing_app/Models/totalbills_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/common_controller.dart';

class AllBills extends StatefulWidget {
  const AllBills({super.key});

  @override
  State<AllBills> createState() => _AllBillsState();
}

class _AllBillsState extends State<AllBills> {
  var commonController = Get.put(CommonController());
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String fSdate = '';
  String fEdate = '';
  String _selectedPathName = '';
  String _selectedShopName = '';
  final _pathStream = StreamController.broadcast();
  final _storeStream = StreamController.broadcast();
  final _storeListStream = StreamController.broadcast();

  filterBills({String? searchText}) {
    commonController.getTotalbills(withLoader: false, search: searchText);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
      useRootNavigator: false,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        fSdate = formatter.format(_startDate);
        fEdate = formatter.format(_endDate);
      });
      commonController.getTotalbills(
          withLoader: false,
          startDate: fSdate,
          endDate: fEdate,
          pathId: _selectedPathName,
          storeId: _selectedShopName);
    }
  }

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  String formatDates(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  void initState() {
    super.initState();
    _pathStream.add(true);

    // Initialize dates to today
    _endDate = DateTime.now();
    _startDate = _endDate;
    fSdate = formatDates(_startDate);
    fEdate = formatDates(_endDate);

    // Call your filter function with today's date after a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonController.getTotalbills(
        withLoader: false,
        startDate: fSdate,
        endDate: fEdate,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Ensure bills are loaded with initial dates
        commonController.getTotalbills(
          withLoader: false,
          startDate: fSdate,
          endDate: fEdate,
        );
      }
    });
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
        body: RefreshIndicator(
          onRefresh: () {
            return refreshValues();
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 110,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(120, 89, 207, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
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
                                  // Navigator.pushReplacementNamed(
                                  //     context, '/adminhome');
                                  Get.toNamed('/adminhome');
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
                              'அனைத்து ரசீதுகள்',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                await Future.wait([
                                  commonController.getbillhistory(
                                      startDate: '', endDate: ''),
                                  commonController.getPath(withLoader: true),
                                ]);
                                Get.toNamed('/billhistory')
                                    ?.then((value) async {
                                  await Future.wait([
                                    commonController.getPath(withLoader: true),
                                    commonController.getbillhistory(),
                                  ]);
                                  _storeListStream.add(true);
                                });
                              } catch (e) {
                                debugPrint("Error: $e");
                              }
                            },
                            child: const Text(
                              'வரலாறு',
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
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectDateRange(context);
                            },
                            child: Container(
                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.calendar_month),
                                  Text(
                                    '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                          // searchBox(context),
                          AppWidgetUtils.buildSizedBox(custHeight: 12),
                          _buildShopNameAndPathNameFilterDropdown(),
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 50,
                          //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(25),
                          //     color: Color.fromRGBO(250, 250, 250, 1),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.5),
                          //         spreadRadius: 1,
                          //         blurRadius: 2,
                          //         offset: Offset(0, 2),
                          //       ),
                          //     ],
                          //   ),
                          //   child: TextFormField(
                          //     controller: search,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         filterbills(search: value);
                          //       });
                          //     },
                          //     decoration: InputDecoration(
                          //       hintText: 'தேடு ரசிது',
                          //       hintStyle: const TextStyle(
                          //         color: Colors.grey,
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.normal,
                          //       ),
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //       ),
                          //       contentPadding:
                          //           EdgeInsets.symmetric(horizontal: 15.0),
                          //       suffixIcon: IconButton(
                          //         onPressed: () {
                          //         },
                          //         icon: Image.asset(
                          //           'assets/images/search.png',
                          //           width: 20,
                          //           height: 20,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          StreamBuilder(
                              stream: _storeListStream.stream,
                              builder: (context, snapshot) {
                                return Obx(() {
                                  final totalsbills = commonController
                                      .totalbillsModel.value?.data;
                                  if (totalsbills == null ||
                                      totalsbills.isEmpty) {
                                    return const Center(
                                        child: Text('ரசிதுகள் இல்லை'));
                                  }
                                  return ListView.builder(
                                    itemCount: totalsbills.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: ((context, index) {
                                      return buildCard(totalsbills[index]);
                                    }),
                                  );
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container searchBox(BuildContext context) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: TextFormField(
        controller: searchController,
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            commonController.getTotalbills(
                withLoader: false,
                search: value,
                startDate: fSdate,
                endDate: fEdate);
          });
        },
        decoration: InputDecoration(
          hintText: 'தேடு ரசீது',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          suffixIcon: IconButton(
            onPressed: () {
              // filterBills(searchText: '');
            },
            icon: Image.asset(
              'assets/images/search.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildCard(Datum data) {
    return InkWell(
      onTap: () async {
        await commonController.getBillDetails(data.billId.toString());
        Get.toNamed('/billdetails2', arguments: {'id': data.billId});
        // Navigator.pushNamed(context, '/billdetails2');
      },
      child: Container(
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
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(120, 89, 217, 1),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectableText(
                          'ID ${data.orderNo}.',
                          style: const TextStyle(color: Colors.white),
                        ),
                        SelectableText(
                          data.date,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
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
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: SelectableText(
                        data.path.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: SelectableText(
                        data.storeName.toString(),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: SelectableText(
                        data.storeAddress.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
            Positioned(
              bottom: 5,
              right: 10,
              child: InkWell(
                onTap: () async {
                  print(data.billId.toString());
                  await commonController.getBillDetails(data.billId.toString());
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => BillDetails1()));
                  Get.toNamed('/billdetails2', arguments: {'id': data.billId});
                },
                child: const Text(
                  'விபரங்களை பார்க்க',
                  style: TextStyle(
                      fontSize: 11, color: Color.fromRGBO(120, 89, 207, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshValues() async {
    await commonController.getTotalbills(withLoader: false);
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Row(
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
                  await commonController.getPathStore(_selectedPathName);
                  await commonController.getTotalbills(
                      withLoader: false,
                      search: searchController.text,
                      startDate: fSdate,
                      endDate: fEdate,
                      pathId: _selectedPathName);
                  _storeListStream.add(true);
                  _storeStream.add(true);
                },
              );
            }),
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
                  await commonController.getTotalbills(
                      withLoader: false,
                      search: searchController.text,
                      startDate: fSdate,
                      endDate: fEdate,
                      pathId: _selectedPathName,
                      storeId: _selectedShopName);
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
      width: MediaQuery.sizeOf(context).width / 2.4,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }
}
