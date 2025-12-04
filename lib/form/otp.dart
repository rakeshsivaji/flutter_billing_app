import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _formKey1 = GlobalKey<FormState>();
  String? phone;
  List<TextEditingController> otp =
      List.generate(4, (i) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(4, (i) => FocusNode());

  @override
  void initState() {
    phone = Get.arguments['phone'].toString();
    super.initState();
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

  @override
  void dispose() {
    for (var controller in otp) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/forget');
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/spbg.png'),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/otp.png',
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
                              'OTP Verification',
                              style: GoogleFonts.roboto(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            const Text(
                              'We just sent a verification code via phone number',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter OTP',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            buildOtpField(),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    resend();
                                  },
                                  child: const Text(
                                    'Resend Code',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            buildSendOtpButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/forget');
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOtpField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(71, 52, 125, 1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: TextField(
              controller: otp[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                contentPadding: EdgeInsets.zero,
              ),
              cursorHeight: 20.0,
              onChanged: (value) {
                if (value.length == 1) {
                  if (index < 3) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSendOtpButton() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(71, 52, 125, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          String otps = otp[0].text.toString() +
              otp[1].text.toString() +
              otp[2].text.toString() +
              otp[3].text.toString();
          confirmOtp(otps);
        },
        child: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void confirmOtp(String otp) async {
    // if (_formKey1.currentState != null && _formKey1.currentState!.validate()) {
    try {
      Map<String, dynamic> map = {'phone': phone, 'otp': otp};
      dynamic response = await CommonService().sendOtp(map);
      if (response['status'] == 1) {
        Get.toNamed('/resetpassword');
        Fluttertoast.showToast(
          msg: response['message'],
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error during OTP confirmation: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred',
        backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
        textColor: Colors.white,
      );
    }
    // }
    // else {
    //   Fluttertoast.showToast(msg: 'Please fill OTP phone number');
    // }
  }

  void resend() async {
    // if (_formKey1.currentState != null && _formKey1.currentState!.validate()) {
    try {
      Map<String, dynamic> map = {'phone': phone};
      dynamic response = await CommonService().sendOtp(map);
      Fluttertoast.showToast(
        msg: response['message'],
        backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error during OTP resend: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred',
        backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
        textColor: Colors.white,
      );
    }
    // } else {
    //   Fluttertoast.showToast(msg: 'Please fill OTP phone number');
    // }
  }
}
