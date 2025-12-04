import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class CustomDropDownButtonFormField extends StatelessWidget {
  final double? height;
  final double? width;
  final String? dropDownValue;
  final String? hintText;
  final String? validationMessage;
  final List<String>? dropDownItems;
  final Function(String?)? onChange;
  final bool? addAllEnable;
  final String? Function(String?)? validator;
  final InputBorder? inputBorder;
  final Color? fillColor;
  final double? borderRadius;
  final List<DropdownMenuItem<String?>>? items;
  final  List<BoxShadow>? boxShadow;

  const CustomDropDownButtonFormField(
      {super.key,
      this.dropDownItems,
      this.height,
      this.width,
      this.dropDownValue,
      this.hintText,
      this.validationMessage,
      this.onChange,
      this.addAllEnable = false,
      this.validator,
      this.inputBorder,
      this.fillColor,
      this.borderRadius,
      this.items, this.boxShadow});

  @override
  Widget build(BuildContext context) {
    final appColor = AppColors();
    return Center(
        child: Container(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0))),
      height: validationMessage != null ? height ?? 0 + 20 : height,
      width: width,
      child: DropdownButtonFormField<String?>(
        value: dropDownValue?.isEmpty == true ? null : dropDownValue,
        focusColor: appColor.whiteColor,
        hint: _buildTextWidget(hintText,
            overflow: TextOverflow.ellipsis, fontSize: 12),
        decoration: InputDecoration(
          border: inputBorder,
          fillColor: fillColor,
          filled: true,
          // focusedErrorBorder:
          //     AppUtils.outlineInputBorder(color: appColor.primaryColor),
          // errorBorder: AppUtils.outlineInputBorder(color: appColor.errorColor),
          // enabledBorder:
          //     AppUtils.outlineInputBorder(color: appColor.greyColor),
          // disabledBorder:
          //     AppUtils.outlineInputBorder(color: appColor.greyColor),
          // focusedBorder:
          //     AppUtils.outlineInputBorder(color: appColor.primaryColor),
          // border: OutlineInputBorder(
          //     borderSide: BorderSide(color: appColor.primaryColor)),
          contentPadding:
              const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
        ),
        isExpanded: true,
        items: dropDownItems?.map((item) {
              return DropdownMenuItem<String?>(
                key: UniqueKey(),
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.nunitoSans(color: appColor.blackColor),
                ),
              );
            }).toList() ??
            items,
        onChanged: onChange,
        validator: validator,
      ),
    ));
  }

  Widget _buildTextWidget(text,
      {TextOverflow? overflow,
      FontWeight? fontWeight,
      double? fontSize,
      Color? color}) {
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
      overflow: overflow,
    );
  }
}
