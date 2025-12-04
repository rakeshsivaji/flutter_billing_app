import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class CustomAppBar extends StatelessWidget {
  final text;
  String? path;
  Function()? onTap;
  CustomAppBar({super.key, required this.text, this.path, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(120, 89, 207, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap ??
                          () {
                            Get.toNamed(path ?? '');
                          },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushReplacementNamed(context, '/enteredbills');
                //   },
                //   child: Container(
                //     height: 40,
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.white,
                //     ),
                //     child: Center(
                //         child: Text(
                //       'பில்களை உள்ளிட்டது',
                //       style: TextStyle(
                //           color: Color.fromRGBO(120, 89, 207, 1), fontSize: 10),
                //     )),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
