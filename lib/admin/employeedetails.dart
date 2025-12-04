import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  var commonController = Get.put(CommonController());

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
        Get.toNamed('/employees');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'பணியாளர் விவரங்கள்',
              path: '/employees',
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
                        horizontal: 20.0, vertical: 20.0),
                    child: Column(
                      children: [
                        buildCardItem(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCardItem(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: commonController
                                      .employeeDetailsModel.value!.data.image ==
                                  null
                              ? const DecorationImage(
                                  image:
                                      AssetImage('assets/images/profile.png'),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image: NetworkImage(commonController
                                      .employeeDetailsModel.value!.data.image),
                                  fit: BoxFit.cover),
                        ),
                      ),
                      // Image.asset(
                      //   'assets/images/profile.png',
                      //   width: 80,
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                      SelectableText(
                        commonController.employeeDetailsModel.value!.data.name,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SelectableText(
                        commonController.employeeDetailsModel.value!.data.phone,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      commonController
                              .employeeDetailsModel.value!.data.email.isEmpty
                          ? Container()
                          : SelectableText(
                              commonController
                                  .employeeDetailsModel.value!.data.email,
                              style: const TextStyle(fontSize: 15),
                            ),
                      const SizedBox(
                        height: 12,
                      ),
                      SelectableText(
                        commonController
                            .employeeDetailsModel.value!.data.address,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SelectableText(
                        'பங்கு உருவாக்க அமைப்புகள் - ' +
                            commonController
                                .employeeDetailsModel.value!.data.stockCreate
                                .toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
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
                  _PopupMenu(commonController
                      .employeeDetailsModel.value!.data.userId
                      .toString());
                },
                child: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),
            Positioned(
              top: 3,
              right: 28,
              child: InkWell(
                onTap: () async {
                  await commonController.getEmployeeDetails(commonController
                      .employeeDetailsModel.value!.data.userId
                      .toString());
                  Get.toNamed('/editemployee', arguments: {
                    'id':
                        commonController.employeeDetailsModel.value!.data.userId
                  });
                },
                child: Image.asset(
                  'assets/images/edit.png',
                  width: 15,
                ),
              ),
            )
          ],
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
}
