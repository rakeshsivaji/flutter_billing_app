// import 'package:billing_app/Models/Neworderstocklist_model.dart';
// import 'package:billing_app/controllers/common_controller.dart';
// import 'package:billing_app/services/common_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class New_Orderlist extends StatefulWidget {
//   const New_Orderlist({super.key});

//   @override
//   State<New_Orderlist> createState() => _New_OrderlistState();
// }

// class _New_OrderlistState extends State<New_Orderlist>
//     with SingleTickerProviderStateMixin {
//   bool? isChecked = true;
//   List<bool> ischecked = [];
//   List<bool> isCheck = [];
//   late TabController _tabController;
//   bool showContainer = false;
//   String selectedId = '';
//   String storeId = '';
//   String lineid = '';
//   List<String> selectedProduct = [];
//   var commonController = Get.put(CommonController());
//   @override
//   void initState() {
//     super.initState();
//     lineid = Get.arguments['lineid'];
//     storeId = Get.arguments['id'].toString();
//     _tabController = TabController(length: 2, vsync: this);
//     if (_tabController.index == 0) {
//       setState(() {
//         showContainer = true;
//       });
//     } else {
//       setState(() {
//         showContainer = false;
//       });
//     }
//   }

//   void showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.deepPurple,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Get.toNamed('/neworderscreen',
//         //     arguments: {'id': lineid, 'status': true});
//         Get.back();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Color.fromRGBO(120, 89, 207, 1),
//         body: Obx(() {
//           return Column(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 100,
//                 margin: EdgeInsets.only(bottom: 10),
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(120, 89, 207, 1),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20.0, vertical: 15.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 5.0),
//                         child: GestureDetector(
//                             onTap: () {
//                               Get.back();
//                               // Navigator.popAndPushNamed(
//                               //     context, '/neworderscreen',
//                               //     arguments: {'id': lineid, 'status': true});
//                             },
//                             child: Icon(
//                               Icons.arrow_back_ios_new_rounded,
//                               color: Colors.white,
//                               size: 18,
//                             )),
//                       ),
//                       SizedBox(
//                         width: 20.0,
//                       ),
//                       Expanded(
//                         child: Text(
//                           'ஆர்டர்கள்',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           await commonController.getPendingOrderList(storeId);
//                           Get.toNamed('/pendingorder',
//                               arguments: {'id': storeId});
//                           print(storeId);
//                         },
//                         child: showContainer
//                             ? Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10.0, vertical: 10.0),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.white,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/pending.png',
//                                       width: 15,
//                                     ),
//                                     SizedBox(
//                                       width: 5.0,
//                                     ),
//                                     Text(
//                                       'நிலுவை ஆர்டர்கள்',
//                                       style: TextStyle(
//                                           color: Colors.red, fontSize: 10),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             : Container(),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(30)),
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 30.0,
//                       ),
//                       // TabBar(
//                       //   dividerHeight: 0.0,
//                       //   indicatorColor: Color.fromRGBO(120, 89, 207, 1),
//                       //   indicator: BoxDecoration(
//                       //     color: Color.fromRGBO(120, 89, 207, 1),
//                       //     borderRadius: BorderRadius.circular(10),
//                       //   ),
//                       //   controller: _tabController,
//                       //   labelStyle: TextStyle(
//                       //     fontSize: 12.0,
//                       //     color: Colors.white,
//                       //   ),
//                       //   unselectedLabelColor: Colors.black,
//                       //   tabs: <Widget>[
//                       //     Tab(
//                       //       text: '      இன்றைய ஆர்டர்கள்      ',
//                       //     ),
//                       //     Tab(
//                       //       text: '      நாளைய ஆர்டர்கள்       ',
//                       //     ),
//                       //     // Tab(
//                       //     //   child: Container(
//                       //     //     height: 50,
//                       //     //     decoration: BoxDecoration(
//                       //     //       borderRadius: BorderRadius.circular(15),
//                       //     //       //color: Color.fromRGBO(120, 89, 207, 1),
//                       //     //     ),
//                       //     //     child: Center(
//                       //     //         child: Text(
//                       //     //       'இன்றைய ஆர்டர்கள்',
//                       //     //       style: TextStyle(
//                       //     //           color: Colors.white, fontSize: 10),
//                       //     //     )),
//                       //     //   ),
//                       //     // ),

//                       //     // Tab(
//                       //     //   child: Container(
//                       //     //     height: 50,
//                       //     //     decoration: BoxDecoration(
//                       //     //       borderRadius: BorderRadius.circular(15),
//                       //     //       //color: Colors.grey[300],
//                       //     //     ),
//                       //     //     child: Center(
//                       //     //       child: Text(
//                       //     //         'நாளைய ஆர்டர்கள்',
//                       //     //         style: TextStyle(
//                       //     //             fontSize: 10, color: Colors.black),
//                       //     //       ),
//                       //     //     ),
//                       //     //   ),
//                       //     // ),
//                       //   ],
//                       // ),
//                       // TabBar(
//                       //   dividerHeight: 0.0,
//                       //   indicatorColor: Color.fromRGBO(120, 89, 207, 1),
//                       //   indicatorPadding:
//                       //       EdgeInsets.only(bottom: 30, top: 15),
//                       //   indicator: BoxDecoration(
//                       //     color: Color.fromRGBO(120, 89, 207, 1),
//                       //     borderRadius: BorderRadius.circular(10),
//                       //   ),
//                       //   automaticIndicatorColorAdjustment: true,
//                       //   controller: _tabController,
//                       //   labelStyle: TextStyle(
//                       //     fontSize: 12.0,
//                       //     color: Colors.white,
//                       //   ),
//                       //   unselectedLabelColor: Colors.black,
//                       //   tabs: <Widget>[
//                       //     Tab(
//                       //       child: Container(
//                       //         height: 2,
//                       //         width: 150,
//                       //       ),
//                       //     ),
//                       //     Tab(
//                       //       child: Container(
//                       //         height: 2,
//                       //         width: 150,
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       // SizedBox(
//                       //   height: 10.0,
//                       // ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Stack(
//                             children: [
//                               SingleChildScrollView(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     if (commonController.orderList ==
//                                         false) ...[
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text('வேறு தகவல்கள் இல்லை'),
//                                         ],
//                                       ),
//                                     ] else ...[
//                                       Container(
//                                         child: ListView.builder(
//                                           itemCount: commonController
//                                               .orderstocklistmodel
//                                               .value!
//                                               .data
//                                               .orderListItem
//                                               .finalData
//                                               .length,
//                                           shrinkWrap: true,
//                                           padding: EdgeInsets.all(0),
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           itemBuilder: ((context, index) {
//                                             ischecked.add(false);
//                                             return buildItem(
//                                                 index,
//                                                 commonController
//                                                     .orderstocklistmodel
//                                                     .value!
//                                                     .data
//                                                     .orderListItem
//                                                     .finalData[index]);
//                                           }),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 15.0, vertical: 18.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 35.0),
//                                               child: SelectableText(
//                                                 'மொத்தம்',
//                                                 style: TextStyle(fontSize: 15),
//                                               ),
//                                             ),
//                                             SelectableText(
//                                               '₹ ' +
//                                                   commonController
//                                                       .orderListModel
//                                                       .value!
//                                                       .data
//                                                       .orderListItem
//                                                       .total
//                                                       .toString(),
//                                               style: TextStyle(fontSize: 15),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 100.0,
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                               Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: Container(
//                                   height: 60,
//                                   width: MediaQuery.of(context).size.width - 50,
//                                   margin: EdgeInsets.only(bottom: 15),
//                                   decoration: BoxDecoration(
//                                     color: Color.fromRGBO(120, 89, 207, 1),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           allDelete();
//                                         },
//                                         child: Text(
//                                           'அனைத்தையும் அழி',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 13),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: VerticalDivider(
//                                           color: Colors.white,
//                                           thickness: 2,
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           confirmOrder();
//                                         },
//                                         child: Text(
//                                           'ஆர்டர் உறுதி',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 13),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         //   Padding(
//                         //     padding: const EdgeInsets.symmetric(
//                         //         horizontal: 20.0),
//                         //     child: Stack(
//                         //       children: [
//                         //         SingleChildScrollView(
//                         //           child: Column(
//                         //             children: [
//                         //               if (commonController.tomorrowList ==
//                         //                   false) ...[
//                         //                 Row(
//                         //                   mainAxisAlignment:
//                         //                       MainAxisAlignment.center,
//                         //                   children: [
//                         //                     Text('வேறு தகவல்கள் இல்லை'),
//                         //                   ],
//                         //                 ),
//                         //               ] else ...[
//                         //                 Container(
//                         //                   child: ListView.builder(
//                         //                     itemCount: commonController
//                         //                         .tomorrowOrderListModel
//                         //                         .value
//                         //                         ?.data
//                         //                         .orderListItem
//                         //                         .tomorrowFinalData
//                         //                         .length,
//                         //                     shrinkWrap: true,
//                         //                     padding: EdgeInsets.all(0),
//                         //                     physics:
//                         //                         NeverScrollableScrollPhysics(),
//                         //                     itemBuilder: ((context, index) {
//                         //                       isCheck.add(false);
//                         //                       return buildItem1(
//                         //                           index,
//                         //                           commonController
//                         //                               .tomorrowOrderListModel
//                         //                               .value!
//                         //                               .data
//                         //                               .orderListItem
//                         //                               .tomorrowFinalData[index]);
//                         //                     }),
//                         //                   ),
//                         //                 ),
//                         //                 Padding(
//                         //                   padding:
//                         //                       const EdgeInsets.symmetric(
//                         //                           horizontal: 15.0,
//                         //                           vertical: 18.0),
//                         //                   child: Row(
//                         //                     mainAxisAlignment:
//                         //                         MainAxisAlignment
//                         //                             .spaceBetween,
//                         //                     children: [
//                         //                       Padding(
//                         //                         padding:
//                         //                             const EdgeInsets.only(
//                         //                                 left: 35.0),
//                         //                         child: SelectableText(
//                         //                           'மொத்தம்',
//                         //                           style: TextStyle(
//                         //                               fontSize: 15),
//                         //                         ),
//                         //                       ),
//                         //                       SelectableText(
//                         //                         '₹ ' +
//                         //                             commonController
//                         //                                 .tomorrowOrderListModel
//                         //                                 .value!
//                         //                                 .data
//                         //                                 .orderListItem
//                         //                                 .total
//                         //                                 .toString(),
//                         //                         style:
//                         //                             TextStyle(fontSize: 15),
//                         //                       ),
//                         //                     ],
//                         //                   ),
//                         //                 ),
//                         //                 SizedBox(
//                         //                   height: 100,
//                         //                 ),
//                         //               ],
//                         //             ],
//                         //           ),
//                         //         ),
//                         //         Align(
//                         //           alignment: Alignment.bottomCenter,
//                         //           child: Container(
//                         //             height: 60,
//                         //             width: 200,
//                         //             margin: EdgeInsets.only(bottom: 15),
//                         //             decoration: BoxDecoration(
//                         //               color:
//                         //                   Color.fromRGBO(120, 89, 207, 1),
//                         //               borderRadius:
//                         //                   BorderRadius.circular(25),
//                         //             ),
//                         //             child: GestureDetector(
//                         //               onTap: () {
//                         //                 // _PopupMenu();
//                         //                 Get.toNamed('/orderscreen');
//                         //               },
//                         //               child: Center(
//                         //                 child: Text(
//                         //                   'முன்கூட்டிய உறுதி',
//                         //                   style: TextStyle(
//                         //                       color: Colors.white,
//                         //                       fontSize: 13),
//                         //                   textAlign: TextAlign.center,
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //         )
//                         //       ],
//                         //     ),
//                         //   ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   buildItem(int index, FinalDatum data) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   delete(data.orderListItemId.toString());
//                 },
//                 child: Icon(
//                   Icons.delete,
//                   color: Colors.red,
//                 ),
//               ),
//               SizedBox(
//                 width: 10.0,
//               ),
//               Expanded(
//                   child: Text(
//                 data.name,
//                 style: TextStyle(fontSize: 15),
//               )),
//               SizedBox(
//                 width: 20.0,
//               ),
//               Text(
//                 'x ' + data.quantity,
//                 textAlign: TextAlign.right,
//                 style: TextStyle(fontSize: 15),
//               ),
//               SizedBox(
//                 width: 30.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Checkbox(
//                     activeColor: Color.fromRGBO(120, 89, 207, 1),
//                     value: ischecked[index],
//                     onChanged: (bool? value) {
//                       setState(() {
//                         ischecked[index] = value!;
//                         ischecked[index]
//                             ? selectedProduct.add(data.productId)
//                             : selectedProduct.remove(data.productId);
//                         // print(data.productId);
//                         // selectedId += data.productId + ',';
//                         // print(selectedId);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               Container(
//                 width: 70,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       data.price,
//                       style: TextStyle(fontSize: 15),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           height: 1.0,
//         ),
//       ],
//     );
//   }

//   // buildItem1(int index, TomorrowFinalDatum data) {
//   //   return Column(
//   //     children: [
//   //       Padding(
//   //         padding: const EdgeInsets.only(right: 15.0, bottom: 10, top: 15),
//   //         child: Row(
//   //           children: [
//   //             // Checkbox(
//   //             //   activeColor: Color.fromRGBO(120, 89, 207, 1),
//   //             //   value: isCheck[index],
//   //             //   onChanged: (bool? value) {
//   //             //     setState(() {
//   //             //       isCheck[index] = value!;
//   //             //     });
//   //             //   },
//   //             // ),
//   //             SizedBox(
//   //               width: 10.0,
//   //             ),
//   //             Expanded(
//   //                 child: SelectableText(
//   //               data.name,
//   //               style: TextStyle(fontSize: 15),
//   //             )),
//   //             SizedBox(
//   //               width: 20.0,
//   //             ),
//   //             Text(
//   //               'x ' + data.quantity,
//   //               style: TextStyle(fontSize: 15),
//   //             ),
//   //             // Expanded(
//   //             //   child: Row(
//   //             //     mainAxisAlignment: MainAxisAlignment.center,
//   //             //     children: [

//   //             //     ],
//   //             //   ),
//   //             // ),
//   //             Expanded(
//   //               child: Row(
//   //                 mainAxisAlignment: MainAxisAlignment.end,
//   //                 children: [
//   //                   Text(
//   //                     '₹ ' + data.price,
//   //                     style: TextStyle(fontSize: 15),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       Divider(
//   //         height: 1.0,
//   //       ),
//   //     ],
//   //   );
//   // }

//   void _PopupMenu(String orderId) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Stack(
//           children: [
//             Container(
//               height: 200,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     'நீங்கள் தொகையை செலுத்த வேண்டுமா?',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 10,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacementNamed(
//                               context, '/orderscreen');
//                         },
//                         child: Container(
//                           width: 100,
//                           height: 50,
//                           padding: EdgeInsets.symmetric(horizontal: 10.0),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'பின்னர் செலுத்தவும்',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 11),
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           await commonController.getOrderDetails(orderId);
//                           Get.toNamed('/shopbills',
//                               arguments: {'orderId': orderId});
//                         },
//                         child: Container(
//                           width: 100,
//                           height: 50,
//                           padding: EdgeInsets.symmetric(horizontal: 10.0),
//                           decoration: BoxDecoration(
//                             color: Color.fromRGBO(120, 89, 207, 1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'இப்போது செலுத்த',
//                               textAlign: TextAlign.center,
//                               style:
//                                   TextStyle(fontSize: 11, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 5,
//               right: 5,
//               height: 30,
//               width: 30,
//               child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Image.asset('assets/images/closeicon.png')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> confirmOrder() async {
//     String last = '';
//     last = selectedProduct.map((item) => item.toString()).join(',');
//     if (last.isNotEmpty) {
//       dynamic response = await CommonService().orderstockConfirm(storeId, lineid);
//       try {
//         if (response["status"] == 1) {
//           showToast("ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது");
//           print(response["order_id"]);

//           _PopupMenu(response["order_id"].toString());
//         } else {
//           showToast(response["message"] ?? "பிழை ஏற்பட்டது");
//         }
//       } catch (error) {
//         print("Error: $error");
//         showToast('பிழை ஏற்பட்டது');
//       }
//     }
//   }

//   void delete(String id) async {
//     dynamic response = await CommonService().deleteOrderList(id);
//     try {
//       if (response["status"] == 1) {
//         showToast(response["message"]);
//         await commonController.getOrderList(Get.arguments['id'].toString());
//         // Get.toNamed('/orderlist');
//       } else {
//         showToast(response["message"] ?? "பிழை ஏற்பட்டது");
//       }
//     } catch (error) {
//       print("Error: $error");
//       showToast('பிழை ஏற்பட்டது');
//     }
//   }

//   void allDelete() async {
//     dynamic response = await CommonService().deleteAllOrderList(storeId);
//     try {
//       if (response["status"] == 1) {
//         showToast(response["message"]);
//         await commonController.getOrderDelivery(withLoader: true);
//         // Get.toNamed('/orderscreen');
//         Get.back();
//       } else {
//         showToast(response["message"] ?? "பிழை ஏற்பட்டது");
//       }
//     } catch (error) {
//       print("Error: $error");
//       showToast('பிழை ஏற்பட்டது');
//     }
//   }

//   // void orderConfirm() async {
//   //   String finalIds = '';
//   //   finalIds = selectedProduct.map((item) => item.toString()).join(',');
//   //   print(finalIds);
//   //   if (finalIds.isNotEmpty) {
//   //     dynamic response =
//   //         await CommonService().orderstockConfirm(finalIds, storeId);
//   //     print("Final ids" + finalIds);
//   //     try {
//   //       if (response["status"] == 1) {
//   //         showToast("ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது");
//   //         print(response["order_id"]);
//   //         // await commonController.getOrderDelivery();
//   //         // Get.toNamed('/orderscreen');
//   //         _PopupMenu(response["order_id"].toString());
//   //       } else {
//   //         showToast(response["message"] ?? "பிழை ஏற்பட்டது");
//   //       }
//   //     } catch (error) {
//   //       print("Error: $error");
//   //       showToast('பிழை ஏற்பட்டது');
//   //     }
//   //   }
//   // }
// }
