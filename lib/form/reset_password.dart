import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

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

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var commonController = Get.put(CommonController());
  final TextEditingController password = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  bool obscureTextPassword = true;
  bool obscureTextPassword2 = true;
  final TextEditingController phone = TextEditingController();
  bool obscureTextPassword1 = true;
  // String obsecureIconPasswordImg = 'assets/images/eyeon.png';
  // String obsecureIconPasswordImg1 = 'assets/images/eyeon.png';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/login');
        return true;
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
                      height: 40.0,
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
                            'Reset Password ',
                            style: GoogleFonts.roboto(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          buildTextField('Enter Phone No',
                              /*'assets/images/call.png',*/ phone),
                          const SizedBox(
                            height: 20.0,
                          ),
                          buildTextField0('Enter Password',
                              /* obsecureIconPasswordImg,*/ password,
                              isPassword: true),
                          const SizedBox(
                            height: 20,
                          ),
                          buildTextField1('Confirm Password',
                              /*obsecureIconPasswordImg,*/ password1,
                              isPassword1: true),
                          const SizedBox(
                            height: 20,
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

  Container buildTextField(String label, TextEditingController controller,
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        // obscureText: isPassword1,
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
            suffixIcon: const Icon(
              Icons.phone,
              color: Colors.white,
            )),
        validator: (value) {
          String? errorMessage;
          if (value == null || value.isEmpty) {
            errorMessage = 'பணியாளர் தொலைபேசி எண்ணை உள்ளிடவும்';
          } else if (value.length < 10) {
            errorMessage = '10 எண்களை உள்ளிடவும்';
          } else if (value.length > 10) {
            errorMessage = 'எண்களை சரி செய்யவும்';
          }

          if (errorMessage != null && mounted) {
            Fluttertoast.showToast(
              msg: errorMessage,
              backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
              textColor: Colors.white,
            );
          } else if (mounted) {
            Fluttertoast.cancel();
          }

          return errorMessage;
        },
      ),
    );
  }

  Container buildTextField0(
      String label, /* String imagePath,*/ TextEditingController controller,
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
        // obscureText: isPassword1,
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
                obscureTextPassword = !obscureTextPassword;
              });
            },
            icon: Icon(
              obscureTextPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
        ),
        validator: (value) {
          String? errorMessage;
          if (value == null || value.isEmpty) {
            errorMessage = 'புதிய கடவுச்சொல்லை உள்ளிடவும்';
            if (mounted) {
              Fluttertoast.showToast(
                msg: errorMessage,
                backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
                textColor: Colors.white,
              );
            }
          } else if (value.length < 6) {
            errorMessage = 'ஆறு எண்களுக்கு மிகாமல் இருக்க வேண்டும்';
            if (mounted) {
              Fluttertoast.showToast(
                msg: errorMessage,
                backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
                textColor: Colors.white,
              );
            }
          } else {
            if (mounted) {
              Fluttertoast.cancel();
            }
          }
          return errorMessage;
        },
      ),
    );
  }

  Container buildTextField1(String label, TextEditingController controller1,
      {bool isPassword1 = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(71, 52, 125, 1),
      ),
      child: TextFormField(
        controller: controller1,
        obscureText: isPassword1 ? obscureTextPassword1 : false,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        // obscureText: isPassword1,
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
                obscureTextPassword1 = !obscureTextPassword1;
              });
            },
            icon: Icon(
              obscureTextPassword1 ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (mounted) {
              Fluttertoast.showToast(
                msg: 'உறுதிப்படுத்தல் கடவுச்சொல்லை உள்ளிடவும்',
                backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
                textColor: Colors.white,
              );
            }
            return 'உறுதிப்படுத்தல் கடவுச்சொல்லை உள்ளிடவும்';
          } else if (value.length < 6) {
            if (mounted) {
              Fluttertoast.showToast(
                msg: 'ஆறு எழுத்துக்களுக்கு குறையாமல் இருக்க வேண்டும்',
                backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
                textColor: Colors.white,
              );
            }
            return 'ஆறு எழுத்துக்களுக்கு குறையாமல் இருக்க வேண்டும்';
          } else {
            if (mounted) {
              Fluttertoast.cancel();
            }
          }
          return null;
        },
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
          resetpassword();
        },
        child: const Text(
          'Reset',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void resetpassword() async {
    // if (_formKey.currentState!.validate()) {
    Map<String, dynamic> map = {
      'phone': phone.text,
      'new_password': password.text,
      'confirm_password': password1.text
    };

    try {
      dynamic response = await CommonService().resetpassword(map);

      if (response['status'] == 1) {
        Get.toNamed('/login');
        Fluttertoast.showToast(
          msg: response['data'],
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: response['data'],
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
        );

        // Get.toNamed('/home');
      }
    } catch (error) {
      print('Error during sign-in: $error');
    }
    // }
  }
}
