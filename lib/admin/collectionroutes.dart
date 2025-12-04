import 'package:billing_app/Models/collectionpath_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Collections_Route extends StatefulWidget {
  const Collections_Route({super.key});

  @override
  State<Collections_Route> createState() => _Collections_RouteState();
}

class _Collections_RouteState extends State<Collections_Route> {
  var commonController = Get.put(CommonController());
  final TextEditingController search = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          body: Column(
            children: [
              CustomAppBar(
                text: 'சேகரிப்பு பாதைகள்',
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
                                filterJobs(search: value);
                              },
                              decoration: InputDecoration(
                                hintText: 'தேடு  பாதை',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
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
                          const SizedBox(
                            height: 20,
                          ),
                          if (commonController.collectionPath == false) ...[
                            const Text('')
                          ] else ...[
                            ListView.builder(
                              itemCount: commonController
                                  .collectionpathmodel.value!.data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return buildCard(commonController
                                    .collectionpathmodel.value!.data[index]);
                              }),
                            ),
                          ],
                          // Container(
                          //   child: Obx(() {
                          //     final collectionpath = commonController
                          //         .collectionpathmodel.value?.data;

                          //     if (collectionpath == null ||
                          //         collectionpath.isEmpty) {
                          //       return Text('சேகரிப்பு பாதை இல்லை');
                          //     }
                          //     return ListView.builder(
                          //       itemCount: collectionpath.length ?? 0,
                          //       shrinkWrap: true,
                          //       physics: NeverScrollableScrollPhysics(),
                          //       itemBuilder: ((context, index) {
                          //         return buildCard(collectionpath[index]);
                          //       }),
                          //     );
                          //   }),
                          // ),
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
              await commonController.getAllPath();
              Get.toNamed('/createsavedcollection');
            },
            backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  filterJobs({
    String? search,
  }) async {
    commonController.getCollectionPath(
      search: search,
    );
  }

  // Container buildCard(Datum data) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.only(bottom: 15),
  //     decoration: BoxDecoration(
  //       color: Color.fromRGBO(120, 89, 207, 0.05),
  //       borderRadius: BorderRadius.circular(15),
  //       border: Border.all(
  //         color: Color.fromRGBO(19, 19, 19, 0.1),
  //         width: 1.0,
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding:
  //               const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Image.asset(
  //                 'assets/images/shopicon.png',
  //                 width: 18,
  //               ),
  //               SizedBox(
  //                 width: 20,
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SelectableText(
  //                       data.pathName,
  //                       style: TextStyle(fontSize: 13),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     SelectableText(
  //                       data.name,
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500, fontSize: 15),
  //                     ),
  //                     SizedBox(
  //                       height: 10.0,
  //                     ),
  //                     SelectableText(data.address),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10.0,
  //               ),
  //             ],
  //           ),
  //         ),
  //         Divider(
  //           height: 0,
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(
  //               left: 60.0, top: 15.0, bottom: 15.0, right: 20.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(child: SelectableText(data.ownerName)),
  //               SizedBox(
  //                 width: 10.0,
  //               ),
  //               SelectableText(data.phone),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  InkWell buildCard(Datum data) {
    return InkWell(
      onTap: () async {
        await commonController.getEditCollectionPath(data.id.toString(),
          callBackFunction: (statusCode) {

          },
        );
        Get.toNamed('/editcollectionpath',
            arguments: {'id': data.id.toString()});
      },
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/route.png',
                width: 18,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      data.name ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SelectableText(
                      data.store.toString() + ' கடைகள்',
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10.0,
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  await commonController
                      .getEditCollectionPath(data.id.toString());
                  Get.toNamed('/editcollectionpath',
                      arguments: {'id': data.id.toString()});
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
                  _PopupMenu(data.id.toString());
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
                    'பாதையை நிச்சயமாக நீக்க விரும்புகிறீர்களா?',
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
              top: 8,
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
    dynamic response = await CommonService().deleteCollectionPath(id);
    try {
      if (response['status'] == 1) {
        showToast(response['data']);
        await commonController.getCollectionPath();
        Get.toNamed('/savedroute');
      } else {
        showToast(response['data'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }
}
