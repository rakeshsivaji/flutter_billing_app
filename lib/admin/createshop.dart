import 'package:billing_app/Models/createshop_Model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateShop extends StatefulWidget {
  const CreateShop({super.key});

  @override
  State<CreateShop> createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {
  List<String> routeList = <String>[
    'Tirunelveli - Tenkasi',
    'Tenkasi - Tirunelveli',
    ''
  ];
  List<String> billList = <String>['தனிப்பட்ட ரசிதுகள்', 'சாதாரண ரசிதுகள்'];
  String routeDropdownValue = '';
  String billDropdownValue = '';
  String selectedValue = '';
  String selectedCard = '';
  String name = '';
  String address = '';
  String ownername = '';
  String phon = '';
  String route = '';
  String route2 = '';

  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final TextEditingController shopName = TextEditingController();
  final TextEditingController shopAddress = TextEditingController();
  final TextEditingController ownerName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController amount2 = TextEditingController();

  final TextEditingController search = TextEditingController();
  List<String> dropdownValues = [];
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    //fetchDropdownValues();
  }

  void getData() async {
    dynamic response = await CommonService().getPath();
    if (response['status'] == 1) {
      setState(() {});
    }
    print(response);
  }

  // void fetchDropdownValues() async {
  //   print('Fetching ');
  //   if (commonController.model.value != null) {
  //     List<String> list1 = [];
  //     for (dynamic item in commonController.pathmodel.value!.data) {
  //       list1.add(item.name.toString());
  //     }
  //     print(list1);
  //     setState(() {
  //       dropdownValues = list1;
  //     });
  //     print('Dropdown  $dropdownValues');
  //     print(list1);
  //   } else {
  //     print('sm null.');
  //   }
  // }

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
        Get.toNamed('/shops');
        return true;
      },
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          body: Obx(() {
            return Column(
              children: [
                CustomAppBar(
                  text: 'கடையை உருவாக்கவும்',
                  path: '/shops',
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
                            horizontal: 25.0, vertical: 10.0),
                        child: Form(
                          key: _formKey1,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 25.0,
                              ),
                              pathithevuBuild(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    route,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              buildFormField('கடை பெயரை உள்ளிடவும்', shopName,
                                  (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    name = 'கடை பெயரை உள்ளிடவும்';
                                  } else {
                                    name = '';
                                  }
                                  if (routeDropdownValue.isEmpty) {
                                    route = 'பாதையை தேர்வு செய்க';
                                  } else {
                                    route = '';
                                  }
                                  if (billDropdownValue.isEmpty) {
                                    route2 = 'ரசிது தேர்வு செய்க';
                                  } else {
                                    route2 = '';
                                  }
                                });
                                return null;
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              addressShop('கடை முகவரி உள்ளிடவும்', shopAddress,
                                  (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    address = 'கடை முகவரி உள்ளிடவும்';
                                  } else {
                                    address = '';
                                  }
                                });
                                return null;
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    address,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              buildFormField(
                                  'கடை நிர்வாகர் பெயரை உள்ளிடவும்', ownerName,
                                  (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    ownername =
                                        'கடை நிர்வாகர் பெயரை உள்ளிடவும்';
                                  } else {
                                    ownername = '';
                                  }
                                });
                                return null;
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ownername,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              buildFormField1(
                                  'கடை தொலைபேசி எண்ணை உள்ளிடவும்', phone,
                                  validator: (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    phon = 'கடை தொலைபேசி எண்ணை உள்ளிடவும்';
                                  } else if (value.length < 10) {
                                    phon = '10 எண்களை உள்ளிடவும்';
                                  } else if (value.length > 10) {
                                    phon = 'எண்களை சரி செய்யவும்';
                                  } else {
                                    phon = '';
                                  }
                                });
                                return null;
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    phon,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              buildFormField1('கடையின் மீதமுள்ள தொகை',
                                  balanceAmountController),
                              const SizedBox(
                                height: 10,
                              ),
                              rasithuthervuBuild(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    route2,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              /*if(billDropdownValue.isNotEmpty&&billDropdownValue=='தனிப்பட்ட ரசிதுகள்')...[*/
                              InkWell(
                                onTap: () async {
                                  await commonController.getcreateshop();
                                  showBottomSheet(
                                    context,
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(120, 89, 217, 0.8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'பொருள் தொகையை திருத்தவும்',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              /*],*/
                              const SizedBox(
                                height: 40.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (clicked == false) {
                                    submit();
                                  }
                                },
                                child: Container(
                                  width: 120,
                                  height: 45,
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
                                            'சேமி',
                                            style:
                                                TextStyle(color: Colors.white),
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
                ),
              ],
            );
          })),
    );
  }

  Container rasithuthervuBuild() {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: DropdownButton<String>(
        isExpanded: true,
        value: billDropdownValue.isEmpty ? null : billDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            billDropdownValue = newValue!;
          });
        },
        hint: const Text(
          'ரசிது தேர்வு செய்க',
          style: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black),
        icon: Image.asset(
          'assets/images/arrowdown.png',
          width: 15,
        ),
        items: billList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  Container pathithevuBuild() {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: DropdownButton<String>(
        isExpanded: true,
        value: routeDropdownValue.isEmpty ? null : routeDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            routeDropdownValue = newValue!;
          });
        },
        hint: const Text(
          'பாதையை தேர்வு செய்க',
          style: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black),
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
    );
  }

  Container addressShop(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: TextFormField(
        maxLines: 20,
        controller: shopAddress,
        decoration: const InputDecoration(
          hintText: 'கடை முகவரியை உள்ளிடவும்',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: validator,
      ),
    );
  }

  Future showBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'பொருள் தொகையை உறுதிப்படுத்தவும்',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
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
                            hintText: 'தேடு பொருள்',
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          // height: Get.height,
                          child: Obx(
                            () {
                              if (commonController
                                      .createShopModel.value?.data ==
                                  null) {
                                return const Text('தயாரிப்புகள் இல்லை');
                              }

                              return ListView.builder(
                                itemCount: commonController
                                    .createShopModel.value?.data.product.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return buildRow(commonController
                                      .createShopModel
                                      .value!
                                      .data
                                      .product[index]);
                                }),
                              );
                              /*     */
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Container buildFormField(String hint, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: TextFormField(
        controller: controller,
        // keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
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
        ),
        validator: validator,
      ),
    );
  }

  Container buildFormField1(String hint, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
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
        ),
        validator: validator,
      ),
    );
  }

  StatefulBuilder buildRow(Product data /*, Category category*/) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                data.image,
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 35.0,
              ),
              Expanded(
                child: Text(
                  data.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                data.amount.toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    amount.text = data.amount;
                    _PopupMenu(
                      data.productId.toString(),
                      data.name,
                    );
                  });
                },
                child: Image.asset(
                  'assets/images/edit.png',
                  width: 17,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // gridMethod(Datum data) {
  //   return StatefulBuilder(builder: (context, setState) {
  //     return InkWell(
  //       onTap: () {
  //         setState(() {
  //           selectedCard = data.productId.toString();
  //         });
  //       },
  //       child: Container(
  //         height: MediaQuery.of(context).size.height,
  //         padding: EdgeInsets.all(0),
  //         decoration: selectedCard == data.productId.toString()
  //             ? BoxDecoration(
  //                 borderRadius: BorderRadius.circular(13),
  //                 color: Colors.white,
  //                 border: Border.all(
  //                   color: Colors.deepPurple,
  //                   width: 2.0,
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.5),
  //                     spreadRadius: 3,
  //                     blurRadius: 2,
  //                     offset: Offset(1, 1),
  //                   ),
  //                 ],
  //               )
  //             : BoxDecoration(
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.2),
  //                     spreadRadius: .2,
  //                     blurRadius: 1,
  //                     offset: Offset(2, 0), // Right shadow
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.2),
  //                     spreadRadius: .2,
  //                     blurRadius: 1,
  //                     offset: Offset(-2, 0), // Left shadow
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.2),
  //                     spreadRadius: .2,
  //                     blurRadius: 1,
  //                     offset: Offset(0, 2), // Bottom shadow
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.2),
  //                     spreadRadius: .2,
  //                     blurRadius: 1,
  //                     offset: Offset(0, -2), // Top shadow
  //                   ),
  //                 ],
  //                 borderRadius: BorderRadius.circular(15),
  //                 color: Color.fromRGBO(255, 255, 255, 1),
  //               ),
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 25,
  //               width: MediaQuery.of(context).size.width,
  //               padding: EdgeInsets.all(2),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
  //                 color: Color.fromRGBO(120, 89, 207, 0.2),
  //               ),
  //               child: Center(
  //                 child: SelectableText(
  //                   data.name,
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 6.0,
  //             ),
  //             Expanded(
  //               child: Container(
  //                 child: Image.network(data.image),
  //               ),
  //             ),
  //             // Stack(
  //             //   children: [
  //             //     Center(
  //             //         child: Image.asset(
  //             //             height: 70, width: 70, 'assets/images/product.png')),
  //             //     Center(
  //             //       child: Image.network(
  //             //         data.image,
  //             //         height: 65,
  //             //         width: 65,
  //             //       ),
  //             //     ),
  //             //   ],
  //             // ),
  //             SizedBox(
  //               height: 6.0,
  //             ),
  //             Container(
  //               // height: 25,
  //               width: 45,
  //               padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
  //               decoration: BoxDecoration(
  //                 color: Color.fromRGBO(19, 19, 19, 0.2),
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //               child: Center(
  //                 child: SelectableText(
  //                   "₹" + data.amount,
  //                   style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 8.0,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  void _PopupMenu(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(120, 89, 217, 1),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0.5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Form(
                      key: _formKey2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              ' ₹  |',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'பொருள் கட்டணம் தொகை',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                fillColor: const Color.fromRGBO(71, 52, 125, 1),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            editAmount(id, amount.text);
                            Navigator.pop(context);
                          });
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
                              'உறுதி',
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
                  child: Image.asset('assets/images/closeicon2.png')),
            ),
          ],
        ),
      ),
    );
  }

  void filterJobs({
    String? search,
  }) async {
    commonController.getallProduct(
      withLoader: false,
      search: search,
    );
  }

  void editAmount(String id, String editamount) async {
    if (_formKey2.currentState!.validate()) {
      try {
        Map<String, dynamic> newData = {
          'product_id': id,
          'amount': amount.text,
        };

        dynamic response = await CommonService().editproductAmount(newData);
        if (response['status'] == 1) {
          await commonController.getcreateshop();
          showToast(response['message']);
          // await commonController.getOrderDelivery(withLoader: true);
        } else {
          showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
        }
      } catch (error) {
        print('Error: $error');
        showToast('பிழை ஏற்பட்டது');
      }
    }
  }

  void submit() async {
    if (_formKey1.currentState!.validate()) {
      if (shopName.text.isEmpty ||
          shopAddress.text.isEmpty ||
          ownerName.text.isEmpty ||
          phone.text.isEmpty ||
          routeDropdownValue.isEmpty ||
          billDropdownValue.isEmpty) {
        return;
      }
      if (phone.text.length < 10) {
        return;
      }
      setState(() {
        clicked = true;
      });
      try {
        Map<String, dynamic> newData = {
          'path_id': commonController.pathId![routeDropdownValue].toString(),
          'name': shopName.text,
          'address': shopAddress.text,
          'owner_name': ownerName.text,
          'phone': phone.text,
          'bill_type': billDropdownValue.toString(),
          'amount': amount.text,
          'old_pending_amount': balanceAmountController.text
        };

        dynamic response = await CommonService().createShop(newData);

        if (response['status'] == 1) {
          showToast(response['message']);
          await commonController.getShops(withLoader: true);
          await commonController.getOrderDelivery(
            withLoader: true,
          );
          Get.toNamed('/shops');
        } else {
          showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
          setState(() {
            clicked = false;
          });
        }
      } catch (error) {
        print('Error: $error');
        showToast('பிழை ஏற்பட்டது');
      }
    }
  }
}
