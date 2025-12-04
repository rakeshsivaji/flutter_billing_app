import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:billing_app/controllers/common_controller.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var commonController = Get.put(CommonController());

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, '/login');
    // });

    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userType = prefs.getString('userType');

    if (isLoggedIn) {
      if (userType == 'Admin') {
        await commonController.getAdminProfile();
        Get.offNamed('/adminhome');
      } else if (userType == 'User') {
        await commonController.getNotification();
        await commonController.getUserProfile();
        Get.offNamed('/home');
      }
    } else {
      Get.offNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/spbg.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Image.asset(
              'assets/images/spl1.png',
              width: 300.0,
              height: 300.0,
            ),
          ),
        ],
      ),
    );
  }
}
