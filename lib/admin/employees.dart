import 'dart:async';

import 'package:billing_app/Models/employee_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees>
    with AutomaticKeepAliveClientMixin {
  var commonController = Get.put(CommonController());
  final TextEditingController search = TextEditingController();
  final _scrollController = ScrollController();
  double _scrollPosition = 0;
  bool switchValue = false;
  final _switchStream = StreamController.broadcast();
  bool showFab = true;

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
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
      _scrollPosition = _scrollController.position.pixels;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (commonController.scrollPosition != null) {
        _scrollController.jumpTo(commonController.scrollPosition!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              text: 'அனைத்து பணியாளர்கள்',
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
                  controller: _scrollController,
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
                              hintText: 'தேடு பணியாளர்',
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
                          height: 20.0,
                        ),
                        Container(
                          child: Obx(() {
                            final employee =
                                commonController.employeemodel.value?.data;
                            if (employee == null || employee.isEmpty) {
                              return const Text('பணியாளர் இல்லை');
                            }
                            return ListView.builder(
                              // controller: _scrollController,
                              itemCount: employee.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return buildCardItem(employee[index]);
                              }),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: showFab
            ? FloatingActionButton(
          onPressed: () async {
            await commonController.getAllColectionPath();
            Get.toNamed('/createemployee');
          },
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        )
            : null,
      ),
    );
  }

  filterJobs({
    String? search,
  }) async {
    commonController.getEmployee(
      withLoader: false,
      search: search,
    );
  }

  Widget buildCardItem(Datum data) {
    return StreamBuilder(
        stream: _switchStream.stream,
        builder: (context, snapshot) {
          switchValue = data.isActive == 'Enable' ? true : false;
          return InkWell(
            onTap: () async {
              commonController.scrollPosition = _scrollPosition;
              await commonController.getEmployeeDetails(data.userId.toString());
              Get.toNamed('/employeedetails');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(120, 89, 207, 0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromRGBO(19, 19, 19, 0.1),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            image: DecorationImage(
                                image: NetworkImage(data.image),
                                fit: BoxFit.cover),
                          ),
                        ),
                        // Image.network(
                        //   data.image,
                        //   width: 30,
                        //   height: 30,
                        // ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                data.name,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SelectableText(
                                data.phone,
                                style: const TextStyle(fontSize: 14),
                              ),
                              // if (data.email == null)
                              //   ...[]
                              // else ...[
                              const SizedBox(
                                height: 8,
                              ),
                              SelectableText(
                                data.email,
                                style: const TextStyle(fontSize: 15),
                              ),
                              // ]
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          _PopupMenu(data.userId.toString());
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      right: 40,
                      child: InkWell(
                        onTap: () async {
                          commonController.scrollPosition = _scrollPosition;
                          await commonController
                              .getEmployeeDetails(data.userId.toString());
                          await commonController.getAllColectionPath(
                              id: data.name);
                          await commonController.getAllColectionPath();
                          Get.toNamed('/editemployee',
                              arguments: {'id': data.userId});
                        },
                        child: Image.asset(
                          'assets/images/edit.png',
                          width: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: SizedBox(
                        height: 10,
                        child: Switch(
                          value: switchValue,
                          onChanged: (value) {
                            commonController.userEnableOrDisable(
                              userId: data.userId.toString(),
                              userStatus: data.isActive == 'Enable'
                                  ? 'Disable'
                                  : 'Enable',
                              onSuccessCallBack: (statusCode) async {
                                if (statusCode == 1) {
                                  await commonController.getEmployee(
                                      withLoader: true);
                                  data.isActive == 'Enable'
                                      ? showToast('வெற்றிகரமாக முடக்கப்பட்டது!')
                                      : showToast(
                                          'வெற்றிகரமாக செயல்படுத்தப்பட்டது!');
                                  _switchStream.add(true);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
                    'பயனரை நிச்சயமாக நீக்க விரும்புகிறீர்களா ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
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
    dynamic response = await CommonService().deleteEmployee(id);
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        await commonController.getEmployee(withLoader: true);
        Get.toNamed('/employees');
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
