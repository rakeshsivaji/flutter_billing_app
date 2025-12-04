import 'dart:io';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin_Profile extends StatefulWidget {
  const Admin_Profile({super.key});

  @override
  State<Admin_Profile> createState() => _Admin_ProfileState();
}

class _Admin_ProfileState extends State<Admin_Profile> {
  bool _isVisible = false;
  bool isChangePasswordExpanded = false;

  final _formKey = GlobalKey<FormState>();
  File? _image;
  XFile? _imageFile;
  TextEditingController name = TextEditingController();
  final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  bool obscureTextPassword = true;
  bool obscureTextPassword2 = true;
  bool obscureTextPassword3 = true;
  bool isEditMode = false;
  bool isprofile = false;
  PlatformFile? image;
  String pass1 = '';
  String pass2 = '';
  String pass3 = '';

  var commonController = Get.put(CommonController());
  @override
  void initState() {
    super.initState();
    name.text = commonController.adminprofilemodel.value?.data.name ?? '';
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imageFile = image;
      });
    }
  }

  void openFiles() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      setState(() {
        image = resultFile.files.first;
      });
      Fluttertoast.showToast(
        msg: 'சுயவிவரப் படம் புதுப்பிக்கப்பட்டது',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 88, 58, 197),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'சுயவிவரத்தைப் புதுப்பிக்க முடியவில்லை',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 88, 58, 197),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      print('Error occurred');
    }
  }

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void saveChanges() async {
    Map<String, dynamic> updatedData = {
      'name': name.text,
    };

    Map? file = {
      'image': _imageFile,
    };

    try {
      var response = await CommonService()
          .updateProfile(updatedData: updatedData, file: file);
      if (response['status'] == 1) {
        await commonController.getAdminProfile();

        Fluttertoast.showToast(
          msg: 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          backgroundColor: const Color.fromARGB(255, 88, 58, 197),
          textColor: Colors.white,
        );
        setState(() {
          isEditMode = false;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'சுயவிவரத்தைப் புதுப்பிக்க முடியவில்லை',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          backgroundColor: const Color.fromARGB(255, 88, 58, 197),
          textColor: Colors.white,
        );
      }
    } catch (error) {
      print('Error updating profile: $error');
      Fluttertoast.showToast(
        msg: 'சுயவிவரத்தைப் புதுப்பிப்பதில் பிழை',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 88, 58, 197),
        textColor: Colors.white,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          body: Stack(
            children: [
              Column(
                children: [
                  CustomAppBar(
                    text: 'சுயவிவரம்',
                    path: '/adminhome',
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              profileBuild(),
                              const SizedBox(height: 20),
                              buildChangePasswordSection(),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!isKeyboardVisible) ...[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: logout,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 224, 224, 1),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(255, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            'வெளியேறு',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget profileBuild() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            _image == null
                ? GestureDetector(
                    onTap: () {
                      if (isEditMode) {
                        _pickImage();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ClipOval(
                        child: Image.network(
                          commonController
                                  .adminprofilemodel.value?.data.image ??
                              '',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                : GestureDetector(
                    onTap: () {
                      if (isEditMode) {
                        _pickImage();
                      }
                    },
                    child: ClipOval(
                      child: Image.file(
                        _image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(width: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isEditMode ? buildEditProfileName() : buildProfileInfo(),
                    isEditMode
                        ? const SizedBox(height: 0)
                        : const SizedBox(
                            height: 20,
                          ),
                    SelectableText(
                      commonController.adminprofilemodel.value?.data.phone ??
                          '',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(
                  icon: Icon(isEditMode ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (isEditMode) {
                      saveChanges();
                    } else {
                      toggleEditMode();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo() {
    return SelectableText(
      commonController.adminprofilemodel.value?.data.name ?? '',
      textAlign: TextAlign.start,
    );
  }

  Widget buildEditProfileName() {
    return TextFormField(
      controller: name,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          
          bottom: 20,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }

  Widget buildChangePasswordSection() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(0.0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          isChangePasswordExpanded = !isChangePasswordExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Colors.grey[100],
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text(
                'கடவுச்சொல்லை மாற்று',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          },
          body: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: oldpassword,
                        // inputFormatters: [
                        //   LengthLimitingTextInputFormatter(8),
                        // ],
                        obscureText: obscureTextPassword,
                        decoration: InputDecoration(
                          hintText: 'பழைய கடவுச்சொல்லை உள்ளிடவும்',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
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
                            onPressed: () {
                              setState(() {
                                obscureTextPassword = !obscureTextPassword;
                              });
                            },
                            icon: Icon(obscureTextPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        validator: (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              pass1 = 'பழைய கடவுச்சொல்லை உள்ளிடவும்';
                            }
                            //  else if (value.length < 6) {
                            //   pass1 =
                            //       'ஆறு வார்த்தைகளுக்கு மிகாமல் இருக்க வேண்டும்';
                            // } 
                            else {
                              pass1 = '';
                            }
                          });
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        pass1,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: newpassword,
                        // inputFormatters: [
                        //   LengthLimitingTextInputFormatter(8),
                        // ],
                        obscureText: obscureTextPassword2,
                        decoration: InputDecoration(
                          hintText: 'புதிய கடவுச்சொல்லை உள்ளிடவும்',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
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
                            onPressed: () {
                              setState(() {
                                obscureTextPassword2 = !obscureTextPassword2;
                              });
                            },
                            icon: Icon(obscureTextPassword2
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        validator: (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              pass2 = 'புதிய கடவுச்சொல்லை உள்ளிடவும்';
                            } else if (value.length < 6) {
                              pass2 =
                                  'ஆறு வார்த்தைகளுக்கு மிகாமல் இருக்க வேண்டும்';
                            } else {
                              pass2 = '';
                            }
                          });
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        pass2,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmpassword,
                        // inputFormatters: [
                        //   LengthLimitingTextInputFormatter(8),
                        // ],
                        obscureText: obscureTextPassword3,
                        decoration: InputDecoration(
                          hintText: 'உறுதிப்படுத்தல் கடவுச்சொல்லை உள்ளிடவும்',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
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
                            onPressed: () {
                              setState(() {
                                obscureTextPassword3 = !obscureTextPassword3;
                              });
                            },
                            icon: Icon(obscureTextPassword3
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        validator: (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              pass3 = 'உறுதிப்படுத்தல் கடவுச்சொல்லை உள்ளிடவும்';
                            } else if (value.length < 6) {
                              pass3 =
                                  'ஆறு வார்த்தைகளுக்கு மிகாமல் இருக்க வேண்டும்';
                            } else {
                              pass3 = '';
                            }
                          });
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        pass3,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('object');
                      changePassword();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(120, 89, 207, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'மேம்படுத்துதல்',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isExpanded: isChangePasswordExpanded,
        ),
      ],
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

  // void logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('auth_token');
  //   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  // }

  void changePassword() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> passwordChangeMap = {
        'old_password': oldpassword.text,
        'new_password': newpassword.text,
        'confirm_password': confirmpassword.text
      };
      try {
        var response = await CommonService().changePassword(passwordChangeMap);

        if (response['status'] == 1) {
          Fluttertoast.showToast(
            msg: 'கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 88, 58, 197),
            textColor: Colors.white,
            fontSize: 16.0,
          );
          setState(() {
            oldpassword.text = '';
            newpassword.text = '';
            confirmpassword.text = '';
            isChangePasswordExpanded == !isChangePasswordExpanded;
          });
        } else {
          Fluttertoast.showToast(
            msg: response['data'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 88, 58, 197),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg:
              'கடவுச்சொல்லை மாற்றுவதில் பிழை. தயவு செய்து மீண்டும் முயற்சிக்கவும்.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 88, 58, 197),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }
}



/**/