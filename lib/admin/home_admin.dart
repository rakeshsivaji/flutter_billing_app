import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Obx(() {
            return ListView(
              padding: const EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/images/closeicon2.png',
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/adminprofile');
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[100],
                                    image: DecorationImage(
                                        image: NetworkImage(commonController
                                                .adminprofilemodel
                                                .value
                                                ?.data
                                                .image ??
                                            ''),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            SelectableText(
                              commonController
                                      .adminprofilemodel.value?.data.name ??
                                  'Admin',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(120, 89, 207, 1),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(25),
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/workers.png',
                    width: 20,
                  ),
                  title: const Text(
                    'அனைத்து பணியாளர்கள்',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    // Navigate immediately, load data in background
                    Get.toNamed('/employees');
                    // Load data without blocking navigation
                    if (commonController.employeemodel.value == null ||
                        commonController.employeemodel.value!.data.isEmpty) {
                      commonController.getEmployee(withLoader: false);
                    }
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/allbills.png',
                    width: 20,
                  ),
                  title: const Text(
                    'அனைத்து ரசிதுகள்',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    // Navigate immediately, load data in parallel in background
                    Get.toNamed('/allbills');
                    // Load data in parallel without blocking navigation
                    Future.wait([
                      if (commonController.totalbillsModel.value == null)
                        commonController.getTotalbills(withLoader: false),
                      if (commonController.pathmodel.value == null)
                        commonController.getPath(withLoader: false),
                    ]);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/orders.png',
                    width: 20,
                  ),
                  title: const Text(
                    'ஆர்டர்கள் பெறப்பட்டன',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    // Navigate immediately, load data in parallel in background
                    Get.toNamed('/orderrecieved');
                    // Load all orders in parallel without blocking navigation
                    Future.wait([
                      if (commonController.pathmodel.value == null)
                        commonController.getPath(withLoader: false),
                      commonController.getReceivedorder(withLoader: false),
                      commonController.getTomorrowReceivedorder(
                          withLoader: false),
                      commonController.getPendingReceivedorder(
                          withLoader: false),
                    ]);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/stocklist1.png',
                    width: 20,
                  ),
                  title: const Text(
                    'பங்கு பட்டியலை உருவாக்கவும்',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    // Navigate immediately, load data in parallel in background
                    Get.toNamed('/admincstlist2');
                    // Load data in parallel without blocking navigation
                    Future.wait([
                      if (commonController.orderdeliverymodel.value == null)
                        commonController.getOrderDelivery(withLoader: false),
                      if (commonController.shopsmodel.value == null ||
                          commonController.shopsmodel.value!.data.isEmpty)
                        commonController.getShops(withLoader: false),
                      commonController.getStock(),
                      commonController.getNoAccessUsers(),
                    ]);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/shop_amount_icon.png',
                    width: 20,
                  ),
                  title: const Text(
                    'கடையின் மீதமுள்ள தொகை',
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    // Navigate immediately, load data in parallel in background
                    Get.toNamed('/shopsBalanceAmount');
                    // Load data in parallel without blocking navigation
                    Future.wait([
                      commonController.getShopsBalanceAmount(
                          sortOrder: 'asc', withLoader: false),
                      if (commonController.pathmodel.value == null)
                        commonController.getPath(withLoader: false),
                    ]);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: Container(
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/logout.png',
                        width: 20,
                      ),
                      title: const Text(
                        'வெளியேறு',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        body: Obx(() {
          return Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/dmenu.png',
                          width: 35,
                        ),
                      ),
                      Row(
                        children: [
                          SelectableText(
                            commonController
                                    .adminprofilemodel.value?.data.name ??
                                'Admin',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          InkWell(
                            onTap: () async {
                              await commonController.getAdminProfile();
                              Get.toNamed('/adminprofile');
                              // Navigator.pushReplacementNamed(
                              //     context, '/adminprofile');
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[100],
                                  image: DecorationImage(
                                      image: NetworkImage(commonController
                                              .adminprofilemodel
                                              .value
                                              ?.data
                                              .image ??
                                          ''),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Container(
                        //   width: 140,
                        //   height: 140,
                        //   margin: EdgeInsets.only(bottom: 20),
                        // ),
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load data in parallel in background
                            Get.toNamed('/adminorderscreen');
                            // Load data in parallel without blocking navigation
                            Future.wait([
                              if (commonController.orderdeliverymodel.value == null)
                                commonController.getOrderDelivery(
                                    withLoader: false),
                              if (commonController.pathmodel.value == null)
                                commonController.getPath(withLoader: false),
                            ]);
                          },
                          child: buildCard(context, 'ஆர்டர்கள்',
                              'assets/images/orderadmin.png', ''),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load data in parallel in background
                            Get.toNamed('/orderrecieved');
                            // Load all orders in parallel without blocking navigation
                            Future.wait([
                              if (commonController.pathmodel.value == null)
                                commonController.getPath(withLoader: false),
                              commonController.getReceivedorder(
                                  withLoader: false),
                              commonController.getTomorrowReceivedorder(
                                  withLoader: false),
                              commonController.getPendingReceivedorder(
                                  withLoader: false),
                            ]);
                          },
                          // child: buildCard(context, 'ஆர்டர்கள் பெறப்பட்டன',
                          //     'assets/images/order1.png', ''),
                          child: Container(
                            width: 140,
                            height: 140,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image:
                                        AssetImage('assets/images/conbg.png'),
                                    fit: BoxFit.cover)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: Image.asset(
                                    'assets/images/order1.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                const Text(
                                  'ஆர்டர்கள் பெறப்பட்டன',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await commonController.getlineshow();
                            Get.toNamed('/adminPayBill');
                          },
                          child: buildCard(
                              context,
                              'ரசீது உள்ளீடுகள்',
                              'assets/images/rasithu_ullidugal.png',
                              '/adminPayBill'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await commonController.getlineshow();
                            Get.toNamed('/lines');
                          },
                          child: buildCard(context, 'வழிகள்',
                              'assets/images/pathroad.png', '/lines'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await commonController.getCollectionPath();
                            Get.toNamed('/savedroute');
                            // Navigator.pushNamed(context, '/savedroute');
                          },
                          child: buildCard(context, 'சேகரிப்பு பாதைகள்',
                              'assets/images/saveroute.png', '/savedroute'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.toNamed('/report');
                          },
                          child: buildCard(context, 'அறிக்கைகள்',
                              'assets/images/statement.png', '/report'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load paths in background
                            Get.toNamed('/routes');
                            // Only load paths if not already loaded
                            if (commonController.pathmodel.value == null) {
                              commonController.getPath(withLoader: false);
                            }
                          },
                          child: buildCard(context, 'பாதைகள்',
                              'assets/images/road.png', '/routes'),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load paths in background
                            // Shops page will load filtered shops for first path
                            Get.toNamed('/shops');
                            // Only load paths if not already loaded
                            if (commonController.pathmodel.value == null) {
                              commonController.getPath(withLoader: false);
                            }
                          },
                          child: buildCard(context, 'கடைகள்',
                              'assets/images/shop.png', '/shops'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load data in background
                            Get.toNamed('/employees');
                            // Load data without blocking navigation
                            if (commonController.employeemodel.value == null ||
                                commonController.employeemodel.value!.data.isEmpty) {
                              commonController.getEmployee(withLoader: false);
                            }
                          },
                          child: buildCard(context, 'பணியாளர்கள்',
                              'assets/images/employees.png', '/employees'),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load data in background
                            Get.toNamed('/categories');
                            // Only load if not already cached
                            if (commonController.categorymodel.value == null ||
                                commonController.categorymodel.value!.data == null ||
                                commonController.categorymodel.value!.data!.isEmpty) {
                              commonController.getCategories(withLoader: false);
                            }
                          },
                          child: buildCard(context, 'வகைகள்',
                              'assets/images/varieties.png', ''),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load data in parallel in background
                            Get.toNamed('/individualbill');
                            // Load data in parallel without blocking navigation
                            Future.wait([
                              if (commonController.pathmodel.value == null)
                                commonController.getPath(withLoader: false),
                              if (commonController.individualBillModel.value == null)
                                commonController.getIndBill(withLoader: false),
                            ]);
                          },
                          child: buildCard(context, 'தனிப்பட்ட ரசிது',
                              'assets/images/homebill.png', '/individualbill'),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate immediately, load data in parallel in background
                            Get.toNamed('/products');
                            // Load data in parallel without blocking navigation
                            Future.wait([
                              if (commonController.productmodel.value == null ||
                                  commonController.productmodel.value!.data.isEmpty)
                                commonController.getallProduct(
                                    withLoader: false),
                              if (commonController.categorymodel.value == null ||
                                  commonController.categorymodel.value!.data == null ||
                                  commonController.categorymodel.value!.data!.isEmpty)
                                commonController.getallCategories(
                                    withLoader: false),
                            ]);
                          },
                          child: buildCard(context, 'பொருள்கள்',
                              'assets/images/box.png', '/products'),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          );
        }),
      ),
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      await prefs.clear();
      // navigatorKey.currentState
      //     ?.pushNamedAndRemoveUntil('/login', (route) => false);
      Navigator.pushReplacementNamed(context, '/login');

      Fluttertoast.showToast(
        msg: 'வெற்றிகரமாக வெளியேறியது',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 88, 58, 197),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Get.offAllNamed('/adminhome');
    }
  }

  Widget buildCard(
      BuildContext context, String text, String imagepath, String route) {
    return Container(
      width: 140,
      height: 140,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
              image: AssetImage('assets/images/conbg.png'), fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 80,
            height: 80,
            child: Image.asset(
              imagepath,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
