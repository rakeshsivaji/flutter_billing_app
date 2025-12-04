import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    if (_formKey.currentState!.validate() &&
        _phoneController.text.length == 10) {
      Map<String, String> data = {'phone': _phoneController.text};
      dynamic response = await CommonService().sendOtp(data);
      if (response['status'] == 1) {
        Fluttertoast.showToast(
          msg: 'Successfully send',
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
        );
        Get.toNamed('/otp', arguments: {'phone': _phoneController.text});
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to send OTP',
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Please enter a valid 10-digit phone number',
        backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/login');
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
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/forget.png',
                        width: 225,
                        height: 225,
                      ),
                      const SizedBox(height: 50.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 25.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0),
                            Text(
                              'Forgot Password',
                              style: GoogleFonts.roboto(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 60),
                            const Text(
                              'Enter mobile number below \n we will send you a verification code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ),
                            const SizedBox(height: 30),
                            Form(
                              key: _formKey,
                              child: buildTextField(
                                'Phone Number',
                                'assets/images/call.png',
                                _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(height: 40.0),
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
          Positioned(
            top: 50,
            left: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/login');
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

  Container buildTextField(
    String label,
    String imagePath,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(71, 52, 125, 1),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: 'Enter $label',
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
              // Handle obscure/reveal password
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
        onPressed: sendOtp,
        child: const Text(
          'Send OTP',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
