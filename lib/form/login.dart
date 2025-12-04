import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var commonController = Get.put(CommonController());
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  bool obscureTextPassword = true;
  String obsecureIconPasswordImg = 'assets/images/eyeon.png';
  // @override
  // void initState() {
  //   super.initState();
  //   // getadminLoginStatus();
  //   // getuserLoginstatus();
  //   checkLoginStatus();
  // }

  // void getadminLoginStatus() async {
  //   bool loggedIn = await CommonService().isSignedIn();
  //   print(loggedIn.toString());
  //   print('object1');
  //   print('object2');
  //   print('object');
  //   print('object');

  //   if (loggedIn) {
  //     await commonController.getAdminProfile();
  //     Get.offNamed('/adminhome');
  //   } else {
  //     Get.offNamed('/login');
  //   }
  // }

  // void getuserLoginstatus() async {
  //   bool loggedIn = await CommonService().isSignedIn2();
  //   print(loggedIn.toString());
  //   print('object1');
  //   print('object2');
  //   if (loggedIn) {
  //     await commonController.getUserProfile();
  //     Get.offNamed('/home');
  //   } else {
  //     Get.offNamed('/login');
  //   }
  // }

  // void checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   String? userType = prefs.getString('userType');

  //   await Future.delayed(Duration(seconds: 2));

  //   if (isLoggedIn) {
  //     if (userType == 'Admin') {
  // await commonController.getAdminProfile();
  //           Get.offNamed('/adminhome');
  //     } else {
  //       Get.offNamed('/home');
  //     }
  //   } else {
  //     Get.offNamed('/login');
  //   }
  // }
  
  // void showToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.deepPurple,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/spbg.png'),
                  fit: BoxFit.cover),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/login.png',
                      width: 225,
                      height: 225,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 25.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white,
                            width: 0.5,
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'LOGIN ',
                            style: GoogleFonts.roboto(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          buildTextField1('Phone Number',
                              'assets/images/call.png', phone),
                          const SizedBox(
                            height: 20.0,
                          ),
                          buildTextField('Enter Password',
                              obsecureIconPasswordImg, password,
                              isPassword: true),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/forget');
                                },
                                child: const Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          buildSigninButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildTextField(
      String label, String imagePath, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(71, 52, 125, 1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureTextPassword : false,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        // obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                if (isPassword) {
                  obscureTextPassword = !obscureTextPassword;
                  obsecureIconPasswordImg = obscureTextPassword
                      ? 'assets/images/eye.png'
                      : 'assets/images/eyeon.png';
                }
                print(obscureTextPassword.toString());
                print(imagePath.toString());
              });
            },
            icon: Image.asset(
              imagePath,
              width: 17,
              height: 17,
            ),
          ),
        ),
      ),
    );
  }

  Container buildTextField1(
      String label, String imagePath, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(71, 52, 125, 1),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: isPassword ? obscureTextPassword : false,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        // obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                if (isPassword) {
                  obscureTextPassword = !obscureTextPassword;
                  obsecureIconPasswordImg = obscureTextPassword
                      ? 'assets/images/eye.png'
                      : 'assets/images/eyeon.png';
                }
                print(obscureTextPassword.toString());
                print(imagePath.toString());
              });
            },
            icon: Image.asset(
              imagePath,
              width: 17,
              height: 17,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSigninButton() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(71, 52, 125, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          login();
        },
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {
        'phone': phone.text,
        'password': password.text,
      };

      try {
        dynamic response = await CommonService().signin(map);

        if (response['status'] == 1) {
          if (response['type'] == 'Admin') {
            await commonController.getAdminProfile();
            Get.toNamed('/adminhome');
          } else {
            await commonController.getUserProfile();
            await commonController.getNotification();
            Get.toNamed('/home');
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(response['message'] ?? 'An error occurred'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        print('Error during sign-in: $error');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('An error occurred'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
